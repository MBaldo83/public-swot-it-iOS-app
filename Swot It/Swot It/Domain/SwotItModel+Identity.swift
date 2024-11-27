import Foundation

protocol Identity {
    var currentAccessToken: String? { get set }
}

extension SwotItModel: IdentityManagementUseCase {
    func loadIdentity() async {
        viewableAccessToken = identity.currentAccessToken
    }
    
    func saveIdentity() async {
        identity.currentAccessToken = viewableAccessToken
    }
}
