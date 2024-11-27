import Foundation

protocol CardGeneratorUseCase {
    func generateCards(for topic: APISavedDeck.SanitizedTopic, count: APISavedDeck.SanitizedQuestionCount) async
}

protocol DeckResourceManagementUseCase {
//    func synchroniseDeckGeneratorCurrentDeck() async
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) async
    func updateDeck(_ deck: APISavedDeck) async
}

class DeckViewHandler: BuildDeckViewHandler {
    
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) {
        
        Task {
            await deckResourceManagementUseCase.saveNewDeck(deck, topic: topic)
        }
    }
    
    func updateDeck(_ deck: APISavedDeck) {
        
        Task {
            await deckResourceManagementUseCase.updateDeck(deck)
        }
    }
    
    
    private let cardGenerator: CardGeneratorUseCase
    private let deckResourceManagementUseCase: DeckResourceManagementUseCase

    init(cardGenerator: CardGeneratorUseCase,
         deckResourceManagementUseCase: DeckResourceManagementUseCase
    ) {
        self.cardGenerator = cardGenerator
        self.deckResourceManagementUseCase = deckResourceManagementUseCase
    }
    
    func generateCardsTapped(
        topic: APISavedDeck.SanitizedTopic,
        count: APISavedDeck.SanitizedQuestionCount
    ) {
        Task {
            await cardGenerator.generateCards(for: topic, count: count)
        }
    }
    
    func saveDeck() {
        Task {
//            await deckResourceManagementUseCase.synchroniseDeckGeneratorCurrentDeck()
        }
    }
}
