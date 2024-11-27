import Foundation

class LocalHostURLProvider: BaseURLProvider {
    func baseURL() -> URL? {
        return URL(string: "http://localhost:8000")
    }
}
