import Foundation

protocol NetworkLayer {
    func send(_ request: URLRequest) async -> Result<Data, NetworkRequestError>
}

enum NetworkIntegrationError: Error {
    case badURL
    case decodingError(Error)
    case requestError(NetworkRequestError)
    case notAuthenticated
    
    var deviceConnectivityError: Bool {
        if case .requestError(let error) = self {
            return error.deviceConnectivityError
        }
        return false
    }
}

enum NetworkRequestError: Error {
    case unexpectedResponse
    case unexpectedStatusCode(Int)
    case networkTransportError(Error)
    
    var deviceConnectivityError: Bool {
        if case .networkTransportError(_) = self {
            return true
        }
        return false
    }
}
