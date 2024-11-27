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
            identity: identity
        )
    }
}
