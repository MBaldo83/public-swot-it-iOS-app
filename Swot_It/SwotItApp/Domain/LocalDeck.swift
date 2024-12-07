import Foundation

// TODO This should be simply Deck, and only available once it's been saved
struct LocalDeck: Equatable, Hashable, Identifiable {
    var id: UUID {
        localId
    }
    let localId: UUID
    var topic: String // Change to Sanitized topic?
    var questionSet: [Question]
    
    struct Question: Equatable, Hashable, Identifiable {
        let id: UUID
        var question: String
        var answer: String
        var submissions: [Submission]

        struct Submission: Equatable, Hashable {
            let result: Result
            let date: Date
            enum Result: Equatable, Hashable {
                case unanswered, incorrect, hard, correct, easy
            }
        }
    }
    
    mutating func updateWithSubmissions(_ submissions: [QuestionSubmission]) {
        for submission in submissions {
            if let index = questionSet.firstIndex(where: { $0.id == submission.questionId }) {
                questionSet[index].submissions.append(submission.submission)
            }
        }
    }
}

// Used to pass around a set of submissions
struct QuestionSubmission {
    let questionId: UUID
    let submission: LocalDeck.Question.Submission
}
