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
            let viewModel = DeckReviewViewModel(deck: deck)
            DeckReviewView(
                viewModel: viewModel,
                viewHandler: deckReviewViewHandler()
            )
        }
    }
}

@MainActor
@Observable public class Router {
    
    enum Route: Hashable {
        case deckDetail(_ deck: LocalDeck)
        case deckReview(_ deck: LocalDeck)
    }
    
    var routePath: [Route] = []
    
    var routeViewBuilder: SwiftUIRouteViewBuilder
    
    init(routeViewBuilder: SwiftUIRouteViewBuilder) {
        self.routeViewBuilder = routeViewBuilder
    }
    
    func view(for route: Route) -> some View {
        routeViewBuilder.view(for: route)
    }
    
    func navigateTo(_ appRoute: Route) {
        routePath.append(appRoute)
    }
}

struct RouterView<Content: View>: View {
    
    @State var router: Router
    // Our root view content
    private let content: Content
    
    init(router: Router,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.router = router
    }
    
    var body: some View {
        NavigationStack(path: $router.routePath) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environment(router)
    }
}
