import Foundation

struct QuestionsGenerated: Equatable {
    let topic: APISavedDeck.SanitizedTopic
    let questions: [Question]
}


// This should be the temporary Question returned by the API
// The locally saved Question must have a UUID generated only when the deck is saved
struct Question: Identifiable, Equatable, Hashable {
    
    //TODO delete
    var id: UUID
    var question: String
    var answer: String

    init(id: UUID = UUID(), question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
    
    enum RecordedTestResult {
        case untested, easy, correct, hard, incorrect
    }
}

enum DeckGenerationProcessResource: Equatable {
    case generatedNewDeck(QuestionsGenerated)
    case savedDeck(LocalDeck)
}
