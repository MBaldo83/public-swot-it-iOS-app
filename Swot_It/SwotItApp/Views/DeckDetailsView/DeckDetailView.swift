import SwiftUI

protocol DeckDetailViewHandler {
    func updatedDeck(_ deck: LocalDeck)
}

struct DeckDetailView: View {
    
    let handler: DeckDetailViewHandler
    @State private var viewModel: DeckDetailViewModel
    @Environment(Router.self) private var router: Router
    
    init(viewModel: DeckDetailViewModel,
         handler: DeckDetailViewHandler) {
        self.viewModel = viewModel
        self.handler = handler
    }

    var body: some View {
        DeckDetailContentView(
            openDeck: $viewModel.openDeck,
            onReviewDeck: { deck in
                router.navigateTo(.deckReview(deck))
            }
        )
        .onChange(of: viewModel.openDeck) { oldValue, newValue in
            self.handler.updatedDeck(newValue)
        }
    }
}
