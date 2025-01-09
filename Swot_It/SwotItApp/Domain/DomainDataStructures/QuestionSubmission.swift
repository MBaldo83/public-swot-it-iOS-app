import Foundation

// Used to describe a submission to a question
struct QuestionSubmission: Hashable, Equatable {
    let questionId: UUID
    let submission: LocalDeck.Question.Submission
}
