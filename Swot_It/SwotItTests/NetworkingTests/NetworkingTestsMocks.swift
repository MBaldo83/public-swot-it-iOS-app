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

// Sample Decodable struct for testing
struct SampleData: Decodable, Equatable {
    let id: Int
    let name: String
}
