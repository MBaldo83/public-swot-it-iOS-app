import Foundation

@MainActor
class SwotItModel: ObservableObject {
    
    @Published var viewableAccessToken: String?
    @Published var userSavedDecks: LoadableResource<[APISavedDeckSummary]> = .initial
    @Published var simplifiedDeckGenerationProcess: LoadableResource<DeckGenerationProcessResource> = .initial
    @Published var openDeck: LoadableResource<APISavedDeck> = .initial
    
    var apiClient: DecksAPIClient
    var identity: Identity
    
    init(apiClient: DecksAPIClient,
         identity: Identity
    ) {
        self.apiClient = apiClient
        self.identity = identity
    }
}
