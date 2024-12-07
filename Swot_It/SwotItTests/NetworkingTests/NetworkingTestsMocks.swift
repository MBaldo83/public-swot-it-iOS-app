import Foundation
@testable import Swot_It

// Mock NetworkLayer to simulate network responses
class MockNetworkLayer: NetworkLayer {
    
    var lastRequest: URLRequest?
    var result: Result<Data, NetworkRequestError> = .failure(.unexpectedStatusCode(404))
    func send(_ request: URLRequest) async -> Result<Data, NetworkRequestError> {
        lastRequest = request
        return result
    }
}

class MockRequestBuilder: RequestBuilding {
    var lastEndpoint: Endpoint?
    var customRequest: URLRequest?

    func buildRequest(from endpoint: Endpoint) -> URLRequest? {
        lastEndpoint = endpoint
        return customRequest
    }
}

class MockBaseURLProvider: BaseURLProvider {
    var lastBaseURL: URL?
    var customBaseURL: URL?

    func baseURL() -> URL? {
        lastBaseURL = customBaseURL
        return customBaseURL
    }
}

class MockIdentity: Identity {
    var currentAccessToken: String?
    var lastAccessTokenSet: String?

    func setAccessToken(_ token: String?) {
        lastAccessTokenSet = token
        currentAccessToken = token
    }
}

class MockDecodingNetworkLayer: DecodingNetworkLayer {
    var lastRequest: URLRequest?
    var result: Result<SampleData, NetworkIntegrationError> = .failure(.requestError(.unexpectedResponse))

    func send<T: Decodable>(_ request: URLRequest, decodeTo type: T.Type) async -> Result<T, NetworkIntegrationError> {
        lastRequest = request
        return result as! Result<T, NetworkIntegrationError>
    }
}
struct SampleData: Decodable, Equatable {
    let id: Int
    let name: String
}
