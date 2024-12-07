import SwiftUI

protocol DeckReviewViewHandler {
    func submitSubmissions(_ submissions: [QuestionSubmission], forDeckId deckId: UUID)
}

struct DeckReviewView: View {
    
    @State private var viewModel: DeckReviewViewModel
    private var viewHandler: DeckReviewViewHandler
    
    @Environment(Router.self) private var router: Router
    
    init(viewModel: DeckReviewViewModel, viewHandler: DeckReviewViewHandler) {
        self.viewModel = viewModel
        self.viewHandler = viewHandler
    }

    var body: some View {
        VStack {
            Text(
                viewModel.state.topic
            )
            .font(.title)
            
            CardDeck(
                deck: $viewModel.state.cards,
                index: $viewModel.state.questionIndex,
                submitResults: submitResults
            )
        }
        .padding()
    }
    
    func submitResults() {
        viewHandler.submitSubmissions(viewModel.questionSubmissions, forDeckId: viewModel.state.id)
    }
}
