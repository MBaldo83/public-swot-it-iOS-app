import Foundation
@testable import Swot_It

extension LocalDeck {
    static func mock(
            localId: UUID = UUID(),
            topic: String = "Mock Deck",
            questionSet: [Question] = []
    ) -> LocalDeck {
        LocalDeck(
            localId: localId,
            topic: topic,
            questionSet: questionSet
        )
    }
}

extension LocalDeck.Question {
    static func mock(
        id: UUID = UUID(),
        question: String = "",
        answer: String = "",
        submissions: [Submission] = []
    ) -> LocalDeck.Question {
        LocalDeck.Question(
            id: id,
            question: question,
            answer: answer,
            submissions: submissions
        )
    }
}

extension LocalDeck.Question.Submission {
    static func mock(
        result: Result = .correct,
        date: Date = .init(timeIntervalSince1970: 0)
    ) -> LocalDeck.Question.Submission {
        .init(
            result: result,
            date: date
        )
    }
}
