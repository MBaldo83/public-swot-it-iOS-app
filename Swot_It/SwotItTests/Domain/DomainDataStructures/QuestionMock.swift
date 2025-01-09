import Foundation
@testable import Swot_It

extension Question {
    static func mock(
        id: UUID = UUID(),
        question: String = "",
        answer: String = ""
    ) -> Question {
        Question(
            id: id,
            question: question,
            answer: answer
        )
    }
}
