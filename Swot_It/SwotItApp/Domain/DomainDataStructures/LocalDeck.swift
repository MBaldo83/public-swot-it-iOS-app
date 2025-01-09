import Foundation

struct LocalDeck: Equatable, Hashable, Identifiable, Codable {
    var id: UUID {
        localId
    }
    let localId: UUID
    var topic: String
    var questionSet: [Question]

    struct Question: Equatable, Hashable, Identifiable, Codable {
        let id: UUID
        var question: String
        var answer: String
        var submissions: [Submission]

        struct Submission: Equatable, Hashable, Codable {
            let result: Result
            let date: Date
            enum Result: Equatable, Hashable, Codable {
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

extension LocalDeck {
    var score: Score {
        var resultCounts: [Question.Submission.Result: Int] = [
            .unanswered: 0,
            .incorrect: 0,
            .hard: 0,
            .correct: 0,
            .easy: 0
        ]
        
        let totalSubmissions = questionSet.flatMap { $0.submissions }.count
        
        for question in questionSet {
            for submission in question.submissions {
                resultCounts[submission.result, default: 0] += 1
            }
        }
        
        guard totalSubmissions > 0 else {
            return Score(unanswered: 0, incorrect: 0, hard: 0, correct: 0, easy: 0)
        }
        
        return Score(
            unanswered: Double(resultCounts[.unanswered] ?? 0) / Double(totalSubmissions) * 100,
            incorrect: Double(resultCounts[.incorrect] ?? 0) / Double(totalSubmissions) * 100,
            hard: Double(resultCounts[.hard] ?? 0) / Double(totalSubmissions) * 100,
            correct: Double(resultCounts[.correct] ?? 0) / Double(totalSubmissions) * 100,
            easy: Double(resultCounts[.easy] ?? 0) / Double(totalSubmissions) * 100
        )
    }
}
