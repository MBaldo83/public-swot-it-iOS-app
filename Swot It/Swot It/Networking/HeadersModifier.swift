import Foundation

// MARK: Header Modifier

extension DecodingNetworkLayer {
    func addHeaders(
        _ headers: [String: String]
    ) -> some DecodingNetworkLayer {
        modified(HeadersModifier(headers: headers))
    }
}

struct HeadersModifier: NetworkingModifier {
    
    private var headers: [String: String]

    init(headers: [String: String]) {
        self.headers = headers
    }
    
    func send<T: Decodable>(request: URLRequest, upstream: some DecodingNetworkLayer, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError> {
        var modifiedRequest = request
        for (key, value) in headers {
            modifiedRequest.setValue(value, forHTTPHeaderField: key)
        }
        return await upstream.send(modifiedRequest, decodeTo: type)
    }
}
