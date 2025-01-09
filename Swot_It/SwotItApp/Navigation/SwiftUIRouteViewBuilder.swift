import SwiftUI

class SwiftUIRouteViewBuilder {
    
    let deckDetailViewHandler: () -> DeckDetailViewHandler
    let deckReviewViewHandler: () -> DeckReviewViewHandler
    
    init(
        deckDetailViewHandler: @escaping () -> DeckDetailViewHandler,
        deckReviewViewHandler: @escaping () -> DeckReviewViewHandler
    ) {
        self.deckDetailViewHandler = deckDetailViewHandler
        self.deckReviewViewHandler = deckReviewViewHandler
    }
    
    @MainActor
    @ViewBuilder func view(for route: Router.Route) -> some View {
        
        switch route {
        case .deckDetail(let deck):
            DeckDetailView(
                viewModel: DeckDetailViewModel(deck: deck),
                handler: deckDetailViewHandler()
            )
        case .deckReview(let deck):
            DeckReviewView(
                deck: deck,
                viewHandler: deckReviewViewHandler()
            )
        case .deckResults(let submissions):
            DeckResultsView(submissions: submissions)
        }
    }
}
