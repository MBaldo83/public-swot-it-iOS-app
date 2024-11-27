import SwiftUI

class SwiftUIRouteViewBuilder {
    
    let deckDetailViewHandler: (LoadOpenDeckUseCaseOutput) -> DeckDetailViewHandler
    
    init(deckDetailViewHandler: @escaping (LoadOpenDeckUseCaseOutput) -> DeckDetailViewHandler) {
        self.deckDetailViewHandler = deckDetailViewHandler
    }
    
    @MainActor @ViewBuilder func view(for route: Router.Route) -> some View {
        
        switch route {
        case .deckDetail(let deck):
    
            let viewModel = DeckDetailViewModel(deck: deck)
            DeckDetailView(
                viewModel: viewModel,
                handler: deckDetailViewHandler(viewModel)
            )
        }
    }
}

@MainActor
@Observable public class Router {
    
    enum Route: Hashable {
        case deckDetail(_ deck: APISavedDeckSummary)
    }
    
    var routePath: [Route] = []
    
    var routeViewBuilder: SwiftUIRouteViewBuilder
    
    init(routeViewBuilder: SwiftUIRouteViewBuilder) {
        self.routeViewBuilder = routeViewBuilder
    }
    
    @ViewBuilder func view(for route: Router.Route) -> some View {
        routeViewBuilder.view(for: route)
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
