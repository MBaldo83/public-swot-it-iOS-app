import SwiftUI

@MainActor
@Observable class DeckReviewViewModel {
    
    struct DeckViewState {
        let topic: String
        let id: UUID
        var questionIndex: Int
        var cards: [QuestionCard]

        struct QuestionCard {
            let id: UUID
            var flipped: Bool
            let question: String
            let answer: String
            var result: Result
            
            enum Result: Int, CaseIterable {
                case unanswered = -1
                case incorrect = 0
                case hard = 1
                case correct = 2
                case easy = 3
                func domainResult() -> LocalDeck.Question.Submission.Result {
                    switch self {
                    case .correct:
                            .correct
                    case .incorrect:
                            .incorrect
                    case .unanswered:
                            .unanswered
                    case .hard:
                            .hard
                    case .easy:
                            .easy
                    }
                }
                func stringValue() -> String {
                    switch self {
                    case .unanswered:
                        ""
                    case .correct:
                        "right"
                    case .incorrect:
                        "fail"
                    case .hard:
                        "hard"
                    case .easy:
                        "easy"
                    }
                }
                
                static func pickableCases() -> [Result] {
                    [.incorrect, .hard, .correct, .easy]
                }
            }
        }
    }
    
    var state: DeckViewState
    
    init(deck: LocalDeck) {
        self.state = .init(
            topic: deck.topic,
            id: deck.id,
            questionIndex: 0,
            cards: deck.questionSet.map { question in
                .init(
                    id: question.id,
                    flipped: false,
                    question: question.question,
                    answer: question.answer,
                    result: .unanswered
                )
            }
        )
    }
    
    var questionSubmissions: [QuestionSubmission] {
        return state.cards.map({
            .init(
                questionId: $0.id,
                submission: .init(
                    result: $0.result.domainResult(),
                    date: .now
                )
            )
        })
    }
}
