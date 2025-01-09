import Foundation

extension NetworkIntegrationError {
    func mapToDomain() -> LoadableResourceError {
        if self.deviceConnectivityError {
            return .deviceConnectivityError
        }
        
        if case .notAuthenticated = self {
            return .notAuthenticated
        }
        
        return .systemError
    }
}
