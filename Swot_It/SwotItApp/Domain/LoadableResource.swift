import Foundation

enum LoadableResource<R: Equatable>: Equatable {
    case initial
    case loading
    case loaded(R)
    case error(LoadableResourceError)
}

enum LoadableResourceError: Error {
    case deviceConnectivityError
    case systemError
    case notAuthenticated
}

extension LoadableResourceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .deviceConnectivityError:
            "Please check your network"
        case .systemError:
            "Oops, there's a problem and we've been notified, please try again later"
        case .notAuthenticated:
            "Please login to access this feature"
        }
    }
}
