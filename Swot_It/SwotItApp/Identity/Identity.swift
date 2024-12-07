import Foundation
import KeychainAccess

class PersistentIdentity: Identity {
    private let storageKey = "accessToken"
    private let keychain = Keychain(service: "uk.co.doubledotdevelopment.github-token")

    var currentAccessToken: String? {
        get {
            keychain[storageKey]
        }
        set {
            keychain[storageKey] = newValue
        }
    }
}
