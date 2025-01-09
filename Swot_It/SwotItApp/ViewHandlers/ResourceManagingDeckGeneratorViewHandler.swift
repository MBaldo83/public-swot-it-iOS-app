import Foundation

protocol CardGeneratorUseCase {
    func generateCards(for topic: QuestionsGenerated.SanitizedTopic, count: QuestionsGenerated.SanitizedQuestionCount) async
}

protocol DeckResourceManagementUseCase {

    func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic) async
    func updateLocalDeck(_ deck: LocalDeck) async
}

class ResourceManagingDeckGeneratorViewHandler: DeckGeneratorViewHandler {
    
    private let cardGenerator: CardGeneratorUseCase
    private let deckResourceManagementUseCase: DeckResourceManagementUseCase

    init(cardGenerator: CardGeneratorUseCase,
         deckResourceManagementUseCase: DeckResourceManagementUseCase
    ) {
        self.cardGenerator = cardGenerator
        self.deckResourceManagementUseCase = deckResourceManagementUseCase
    }
    
    func saveNewDeck(_ deck: [Question], topic: QuestionsGenerated.SanitizedTopic) {
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
        topic: QuestionsGenerated.SanitizedTopic,
        count: QuestionsGenerated.SanitizedQuestionCount
    ) {
        Task {
            await cardGenerator.generateCards(for: topic, count: count)
        }
    }
}
