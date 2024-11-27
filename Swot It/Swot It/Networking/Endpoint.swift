import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var urlComponents: [String: String] { get }
    var headers: [String: String] { get }
    var httpBody: Data? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
