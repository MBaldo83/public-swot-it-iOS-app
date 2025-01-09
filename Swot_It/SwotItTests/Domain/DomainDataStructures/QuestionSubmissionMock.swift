import Foundation
@testable import Swot_It

extension QuestionSubmission {
    static func mock(
        questionId: UUID = UUID(),
        submission: LocalDeck.Question.Submission = .mock()
    ) -> QuestionSubmission {
        QuestionSubmission(
            questionId: questionId,
            submission: submission
        )
    }
}
