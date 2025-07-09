import SwiftUI

struct AppRootView: View {
    @StateObject private var authManager = AuthManager()
    @State private var attemptedBiometric = false
    @State private var authenticationFailed = false
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                ContentView()
            } else {
                SplashLockView(
                    authenticationFailed: authenticationFailed && attemptedBiometric,
                    onRetry: {
                        startAuthentication()
                    }
                )
            }
        }
        .onAppear {
            if !attemptedBiometric {
                startAuthentication()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if !authManager.isAuthenticated {
                startAuthentication()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            authManager.isAuthenticated = false
        }
        .onOpenURL { url in
            print("🔗 Deeplink erkannt: \(url.absoluteString)")
            if url.absoluteString == "nebuliton://start" {
                APIClient.sendPowerSignal("start")
            } else if url.absoluteString == "nebuliton://stop" {
                APIClient.sendPowerSignal("stop")
            }
        }
    }
    
    private func startAuthentication() {
        attemptedBiometric = true
        authenticationFailed = false
        
        if UserDefaults.standard.bool(forKey: "useBiometricLock") {
            authManager.authenticate { success in
                DispatchQueue.main.async {
                    if success {
                        authManager.isAuthenticated = true
                    } else {
                        authenticationFailed = true
                    }
                }
            }
        } else {
            authManager.isAuthenticated = true
        }
    }
}
