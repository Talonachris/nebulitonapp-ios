import Foundation
import LocalAuthentication

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAuthenticating = false

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        isAuthenticating = true

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Unlock Nebuliton"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    self.isAuthenticated = success
                    self.isAuthenticating = false
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.isAuthenticating = false
                completion(false)
            }
        }
    }
}
