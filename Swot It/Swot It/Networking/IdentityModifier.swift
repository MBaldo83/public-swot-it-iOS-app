import Foundation

// MARK: Identity Modifier

struct IdentityModifier: NetworkingModifier {
    
    private let identity: Identity

    init(identity: Identity) {
        self.identity = identity
    }
    
    func send<T: Decodable>(request: URLRequest, upstream: some DecodingNetworkLayer, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError> {
        
        guard let accessToken = identity.currentAccessToken else {
            return .failure(.notAuthenticated)
        }
        
        var modifiedRequest = request
        modifiedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return await upstream.send(modifiedRequest, decodeTo: type)
    }
}

// Extension to add IdentityModifier to DecodingNetworkLayer
extension DecodingNetworkLayer {
    func addIdentity(_ identity: Identity) -> some DecodingNetworkLayer {
        modified(IdentityModifier(identity: identity))
    }
}
