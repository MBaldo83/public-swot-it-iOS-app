import SwiftUI

protocol DeckReviewViewHandler {
    func submitSubmissions(_ submissions: [QuestionSubmission], forDeckId deckId: UUID)
}

struct DeckReviewView: View {
    
    @State private var viewState: DeckViewState
    private var deck: LocalDeck
    private var viewHandler: DeckReviewViewHandler
    @Environment(Router.self) private var router: Router
    
    init(deck: LocalDeck,
         viewHandler: DeckReviewViewHandler
    ) {
        self.deck = deck
        self.viewHandler = viewHandler
        self.viewState = deck.map()
    }

    var body: some View {
        VStack {
            Text(
                viewState.topic
            )
            .font(.title)
            
            CardDeck(
                deck: $viewState.cards,
                index: $viewState.questionIndex,
                submitResults: submitResults
            )
        }
        .padding()
    }
    
    func submitResults() {
        viewHandler.submitSubmissions(viewState.questionSubmissions, forDeckId: deck.localId)
        router.navigateTo(.deckResults(submissions: viewState.questionSubmissions))
    }
}

extension LocalDeck {
    func map() -> DeckViewState {
        return .init(
            topic: self.topic,
            id: self.id,
            questionIndex: 0,
            cards: self.questionSet.map { question in
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
}

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

extension DeckViewState {
    var questionSubmissions: [QuestionSubmission] {
        return self.cards.map({
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
