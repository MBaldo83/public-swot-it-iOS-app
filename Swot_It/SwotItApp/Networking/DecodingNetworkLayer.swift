import Foundation

protocol DecodingNetworkLayer {
    func send<T: Decodable>(_ request: URLRequest, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError>
}

class JSONDecodingNetworkLayer: DecodingNetworkLayer {
    private let wrapped: NetworkLayer

    init(wrapping networkLayer: NetworkLayer) {
        self.wrapped = networkLayer
    }

    func send<T: Decodable>(_ request: URLRequest, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError> {
        let result = await wrapped.send(request)
        
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                return .success(decodedObject)
            } catch {
                return .failure(.decodingError(error))
            }
        case .failure(let error):
            return .failure(.requestError(error))
        }
    }
}
