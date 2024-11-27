protocol IdentityManagementUseCase {
    func loadIdentity() async
    func saveIdentity() async
}

class IdentityUseCaseProfileViewHandler: ProfileViewHandler {
    
    private let identityManagementUseCase: IdentityManagementUseCase
    
    init(identityManagementUseCase: IdentityManagementUseCase) {
        self.identityManagementUseCase = identityManagementUseCase
    }
    
    func onViewAppear() {
        Task {
            await identityManagementUseCase.loadIdentity()
        }
    }
    
    func accessTokenSaved() {
        Task {
            await identityManagementUseCase.saveIdentity()
        }
    }
}
