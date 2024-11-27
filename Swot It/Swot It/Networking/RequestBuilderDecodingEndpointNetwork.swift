import Foundation

protocol DecodingEndpointNetwork {
    func send<T: Decodable>(_ endpoint: Endpoint, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError>
}

class RequestBuilderDecodingEndpointNetwork: DecodingEndpointNetwork {
    private let requestBuilder: RequestBuilding
    private let networkLayer: DecodingNetworkLayer

    init(requestBuilder: RequestBuilding, networkLayer: DecodingNetworkLayer) {
        self.requestBuilder = requestBuilder
        self.networkLayer = networkLayer
    }

    func send<T: Decodable>(_ endpoint: Endpoint, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError> {
        guard let request = requestBuilder.buildRequest(from: endpoint) else {
            return .failure(.badURL)
        }
        
        return await networkLayer.send(request, decodeTo: type)
    }
}
