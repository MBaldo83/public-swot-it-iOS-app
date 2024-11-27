import Foundation

struct URLSessionNetworkLayer: NetworkLayer {
    func send(_ request: URLRequest) async -> Result<Data, NetworkRequestError> {
        do {
            // Perform the network call
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP response status
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unexpectedResponse)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.unexpectedStatusCode(httpResponse.statusCode))
            }
            
            return .success(data)

        } catch {
            return .failure(.networkTransportError(error))
        }
    }
}
