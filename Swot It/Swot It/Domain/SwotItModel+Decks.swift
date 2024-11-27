import Foundation

protocol DecksAPIClient {
    
    func generateCards(topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount) async -> Result<[Question], LoadableResourceError>
    func loadDecks() async -> Result<[APISavedDeckSummary], LoadableResourceError>
    func loadDeck(_ id: String) async -> Result<APISavedDeck, LoadableResourceError>
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) async -> Result<String, LoadableResourceError>
    func updateDeck(_ deck: APISavedDeck) async -> Result<String, LoadableResourceError>
}

extension SwotItModel: CardGeneratorUseCase {
    
    func generateCards(for topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount) async {
        
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
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) async {
        
        simplifiedDeckGenerationProcess = .loading
        let deckResult = await apiClient.saveNewDeck(deck, topic: topic)
        switch deckResult {
        case .success(let deckIdentifier):
            simplifiedDeckGenerationProcess = .loaded(
                .savedDeck(
                    .init(
                        apiId: deckIdentifier,
                        topic: topic.topic,
                        questionSet: deck
                    )
                )
            )
        case .failure(let error):
            simplifiedDeckGenerationProcess = .error(error)
        }
    }
    
    func updateDeck(_ deck: APISavedDeck) async {
        
        simplifiedDeckGenerationProcess = .loading
        let deckResult = await apiClient.updateDeck(deck)
        switch deckResult {
        case .success(let deckIdentifier):
            simplifiedDeckGenerationProcess = .loaded(
                .savedDeck(
                    .init(
                        apiId: deckIdentifier,
                        topic: deck.topic,
                        questionSet: deck.questionSet
                    )
                )
            )
        case .failure(let error):
            simplifiedDeckGenerationProcess = .error(error)
        }
    }
}

extension SwotItModel: LoadDecksUseCase {
    func loadDecks() async {
        userSavedDecks = .loading
        let decksResult = await apiClient.loadDecks()
        switch decksResult {
        case .success(let decks):
            userSavedDecks = .loaded(decks)
        case .failure(let error):
            userSavedDecks = .error(error)
        }
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
