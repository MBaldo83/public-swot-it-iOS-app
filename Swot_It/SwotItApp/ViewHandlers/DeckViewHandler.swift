import Foundation

protocol CardGeneratorUseCase {
    func generateCards(for topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount) async
}

protocol DeckResourceManagementUseCase {

    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) async
    func updateLocalDeck(_ deck: LocalDeck) async
}

class DeckViewHandler: BuildDeckViewHandler {
    
    private let cardGenerator: CardGeneratorUseCase
    private let deckResourceManagementUseCase: DeckResourceManagementUseCase

    init(cardGenerator: CardGeneratorUseCase,
         deckResourceManagementUseCase: DeckResourceManagementUseCase
    ) {
        self.cardGenerator = cardGenerator
        self.deckResourceManagementUseCase = deckResourceManagementUseCase
    }
    
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) {
        Task {
            await deckResourceManagementUseCase.saveNewDeck(deck, topic: topic)
        }
    }
    
    func updateDeck(_ deck: LocalDeck) {
        Task {
            await deckResourceManagementUseCase.updateLocalDeck(deck)
        }
    }
    
    func generateCardsTapped(
        topic: APISavedDeck.SanitizedTopic,
        count: APISavedDeck.SanitizedQuestionCount
    ) {
        Task {
            await cardGenerator.generateCards(for: topic, count: count)
        }
    }
}
