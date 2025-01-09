import Foundation

// This should be the temporary Question returned by the API
// The locally saved Question must have a UUID generated only when the deck is saved
struct Question: Identifiable, Equatable, Hashable {
    
    var id: UUID // This id is to allow the Question to be identifiable
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
    case savedDeck(LocalDeck)
}
