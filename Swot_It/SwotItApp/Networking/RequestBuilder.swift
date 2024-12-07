import Foundation

protocol BaseURLProvider {
    func baseURL() -> URL?
}

class RequestBuilder: RequestBuilding {
    private let baseURLProvider: BaseURLProvider

    init(baseURLProvider: BaseURLProvider) {
        self.baseURLProvider = baseURLProvider
    }

    func buildRequest(from endpoint: Endpoint) -> URLRequest? {
        guard let baseURL = baseURLProvider.baseURL(),
              var urlComponentsObject = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            return nil
        }

        urlComponentsObject.queryItems = endpoint.urlComponents.map { URLQueryItem(name: $0.key, value: $0.value) }        
        guard let finalURL = urlComponentsObject.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        for (headerField, headerValue) in endpoint.headers {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.httpBody
        return request
    }
}
