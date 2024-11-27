import Foundation

struct QuestionsGenerated: Equatable {
    let topic: APISavedDeck.SanitizedTopic
    let questions: [Question]
}

struct Question: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var question: String
    var answer: String

    init(id: UUID = UUID(), question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

enum DeckGenerationProcessResource: Equatable {
    case generatedNewDeck(QuestionsGenerated)
    case savedDeck(APISavedDeck)
}
