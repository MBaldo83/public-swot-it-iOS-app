import Foundation

struct AppLaunchFactory {
    
    @MainActor func makeIdentity() -> Identity {
        PersistentIdentity()
    }
    
    @MainActor func makeDecksAPIClient(identity: Identity) -> DecksAPIClient {
        let baseNetworking = JSONDecodingNetworkLayer(
            wrapping: URLSessionNetworkLayer()
        )
        
        let requestBuilder = RequestBuilder(baseURLProvider: LocalHostURLProvider())
        let authenticatedNetworking = RequestBuilderDecodingEndpointNetwork(
            requestBuilder: requestBuilder,
            networkLayer: baseNetworking
                .addIdentity(identity)
        )
        return NetworkDecksAPIClient { authenticatedNetworking }
    }
    
    @MainActor func makeModel(apiClient: DecksAPIClient, identity: Identity) -> SwotItModel {
        return SwotItModel(
            apiClient: apiClient,
            localStorageClient: InMemoryLocalStorage(),
            identity: identity
        )
    }
}

// TODO - this needs to be real local storage (not in memory), and thread safe!
class InMemoryLocalStorage: LocalStorageClient {
    
    private var inMemoryDecks = [LocalDeck]()
    
    func loadDecks() async -> Result<[LocalDeck], LoadableResourceError> {
        return .success(inMemoryDecks)
    }
    
    func updateDeck(_ deck: LocalDeck) async -> Result<LocalDeck, LoadableResourceError> {
        
        guard let index = inMemoryDecks.firstIndex(where: { $0.localId == deck.localId }) else {
            return .failure(.systemError)
        }
        inMemoryDecks[index] = deck
        return .success(deck)
    }
    
    func saveNewDeck(_ deck: [Question], topic: APISavedDeck.SanitizedTopic) async -> Result<LocalDeck, LoadableResourceError> {
        
        let localDeck: LocalDeck = .init(
            localId: UUID(),
            topic: topic.topic,
            questionSet: deck.map {
                .init(
                    id: UUID(),
                    question: $0.question,
                    answer: $0.answer,
                    submissions: []
                )
            }
        )
        inMemoryDecks.append(localDeck)
        return .success(localDeck)
    }
}
