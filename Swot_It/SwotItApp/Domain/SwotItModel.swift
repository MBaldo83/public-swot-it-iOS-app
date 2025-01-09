import Foundation

@MainActor
class SwotItModel: ObservableObject {
    
    @Published var viewableAccessToken: String?
    @Published var simplifiedDeckGenerationProcess: LoadableResource<DeckGenerationProcessResource> = .initial
    @Published var localUserSavedDecks: LoadableResource<[LocalDeck]> = .initial
    
    var apiClient: DecksAPIClient
    var localStorageClient: LocalStorageClient
    var identity: Identity
    
    init(apiClient: DecksAPIClient,
         localStorageClient: LocalStorageClient,
         identity: Identity
    ) {
        self.apiClient = apiClient
        self.identity = identity
        self.localStorageClient = localStorageClient
    }
}
