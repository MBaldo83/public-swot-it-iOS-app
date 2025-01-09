import Foundation

protocol DeckStorage {
    func saveDeck(_ deck: LocalDeck) throws
    func loadAllDecks() throws -> [LocalDeck]
}

actor PersistentLocalStorageClient: LocalStorageClient {
    
    private let storageBuilder: () -> DeckStorage?
    
    init(storageBuilder: @escaping () -> DeckStorage?) {
        self.storageBuilder = storageBuilder
    }
    
    func loadDecks() async -> Result<[LocalDeck], LoadableResourceError> {
        
        guard let storage = storageBuilder() else { return .failure(.localStorageError) }
        
        do {
            let decks = try storage.loadAllDecks()
            return .success(decks)
        } catch {
            return .failure(.localStorageError)
        }
    }
    
    func updateDeck(_ deck: LocalDeck) async -> Result<LocalDeck, LoadableResourceError> {
        overwriteOrSaveDeck(deck)
    }
    
    func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic) async -> Result<LocalDeck, LoadableResourceError> {
        overwriteOrSaveDeck(
            .init(
                localId: UUID(),
                topic: topic.topic,
                questionSet: deck.map {
                    .init(
                        id: UUID(),
                        question: $0.question,
                        answer: $0.answer,
                        submissions: []
                    )
                }
            )
        )
    }
    
    private func overwriteOrSaveDeck(_ deck: LocalDeck) -> Result<LocalDeck, LoadableResourceError> {
        
        guard let storage = storageBuilder() else { return .failure(.localStorageError) }
        
        do {
            try storage.saveDeck(deck)
            return .success(deck)
        } catch {
            return .failure(.localStorageError)
        }
    }
}
