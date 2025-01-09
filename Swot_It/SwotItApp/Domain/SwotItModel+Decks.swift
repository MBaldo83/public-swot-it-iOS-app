import Foundation

protocol DecksAPIClient {
    func generateCards(topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount) async -> Result<[Question], LoadableResourceError>
}

protocol LocalStorageClient {
    func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic) async -> Result<LocalDeck, LoadableResourceError>
    func updateDeck(_ deck: LocalDeck) async -> Result<LocalDeck, LoadableResourceError>
    func loadDecks() async -> Result<[LocalDeck], LoadableResourceError>
}

extension SwotItModel: CardGeneratorUseCase {
    
    func generateCards(for topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount) async {
        simplifiedDeckGenerationProcess = .loading
        let cardsResult = await apiClient.generateCards(topic: topic, count: count)
        switch cardsResult {
        case .success(let questions):
            simplifiedDeckGenerationProcess = .loaded(
                .generatedNewDeck(
                    .init(topic: topic, questions: questions)
                )
            )
        case .failure(let failure):
            simplifiedDeckGenerationProcess = .error(failure)
        }
    }
}

extension SwotItModel: DeckResourceManagementUseCase {
    
    // change deck to questions
    func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic) async {
        
        simplifiedDeckGenerationProcess = .loading
        let storageResult = await localStorageClient.saveNewDeck(deck, topic: topic)
        
        switch storageResult {
        case .success(let localDeck):
            localUserSavedDecks.append(localDeck)
            simplifiedDeckGenerationProcess = .loaded(
                .savedDeck(localDeck)
            )
        case .failure(let error):
            simplifiedDeckGenerationProcess = .error(error)
        }
    }
    
    func updateLocalDeck(_ deck: LocalDeck) async {
        let storageResult = await localStorageClient.updateDeck(deck)
        switch storageResult {
        case .success(let localDeck):
            updateBoundViewDeckState(localDeck)
        case .failure(let error):
            localUserSavedDecks = .error(error)
        }
    }
    
    private func updateBoundViewDeckState(_ deck: LocalDeck) {
        guard case let .loaded(decks) = localUserSavedDecks,
              let index = decks.firstIndex(where: { $0.localId == deck.localId }) else {
            fatalError("ERROR: FAILED to updateLocalDeck")
        }
        var tmpDecks = decks
        tmpDecks[index] = deck
        
        localUserSavedDecks = .loaded(tmpDecks)
    }
}

extension SwotItModel: LoadDecksUseCase {
    func loadDecks() async {
        localUserSavedDecks = .loading
        let decksResult = await localStorageClient.loadDecks()
        switch decksResult {
        case .success(let decks):
            localUserSavedDecks = .loaded(decks)
        case .failure(let error):
            localUserSavedDecks = .error(error)
        }
    }
}

extension SwotItModel: ResultsUpdater {
    func updateResults(_ submissions: [QuestionSubmission], forDeckId deckId: UUID) async {
        // Check if the decks are loaded
        guard case let .loaded(decks) = localUserSavedDecks else {
            print("Decks have not been loaded yet.")
            return
        }
        
        // Find the deck with the specified ID
        guard let index = decks.firstIndex(where: { $0.localId == deckId }) else {
            print("Deck with ID \(deckId) not found.")
            return
        }
        
        // Update the deck with the new results
        var updatedDeck = decks[index]
        // Assuming `updateWithSubmissions` is a method to update the deck with new submissions
        updatedDeck.updateWithSubmissions(submissions)
        
        await self.updateLocalDeck(updatedDeck)
    }
}

extension LoadableResource where R: RangeReplaceableCollection, R.Element: Equatable {
    mutating func append(_ element: R.Element) {
        switch self {
        case .loaded(var currentArray):
            currentArray.append(element)
            self = .loaded(currentArray)
        case .initial:
            self = .loaded([element] as! R)
        default:
            break
        }
    }
}
