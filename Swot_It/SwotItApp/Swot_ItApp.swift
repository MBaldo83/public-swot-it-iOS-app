import SwiftUI

@main
struct SwotItApp: App {
    @StateObject private var model: SwotItModel
    private var apiClient: DecksAPIClient
    
    init() {
        let launchFactory = AppLaunchFactory()
        let identity = launchFactory.makeIdentity()
        let newApiClient = launchFactory.makeDecksAPIClient(identity: identity)
        
        _model = StateObject(
            wrappedValue: launchFactory.makeModel(apiClient: newApiClient, identity: identity)
        )
        self.apiClient = newApiClient
    }
    
    private var deckViewHandler: DeckGeneratorViewHandler {
        ResourceManagingDeckGeneratorViewHandler(
            cardGenerator: model,
            deckResourceManagementUseCase: model
        )
    }
    
    private var decksViewHandler: DecksViewHandler {
        LoadDecksDecksViewHandler(
            loadDecksUseCase: model
        )
    }
    
    private var profileViewHandler: ProfileViewHandler {
        IdentityUseCaseProfileViewHandler(
            identityManagementUseCase: model
        )
    }
    
    private func deckDetailViewHandler() -> DeckDetailViewHandler {
        return LoadDeckUseCaseDeckDetailViewHandler(
            deckResourceManagementUseCase: model
        )
    }
    
    private func deckReviewViewHandler() -> DeckReviewViewHandler {
        return ResultsUpdatingDeckReviewViewHandler(
            resultsUpdater: model
        )
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView(
                buildTabZero: {
                    DeckGeneratorViewFactory(
                        handler: deckViewHandler
                    ).make()
                },
                buildTabOne: {
                    RouterView(
                        router: Router(
                            routeViewBuilder: SwiftUIRouteViewBuilder(
                                deckDetailViewHandler: deckDetailViewHandler,
                                deckReviewViewHandler: deckReviewViewHandler
                            )
                        )
                    ) {
                        DecksView(handler: decksViewHandler)
                    }
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                        Text("Decks")
                    }
                },
                buildTabTwo: {
                    ProfileView(handler: profileViewHandler)
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                }
            )
            .environmentObject(model)
        }
    }
}
