import SwiftUI

struct SplashLockView: View {
    var authenticationFailed: Bool
    var onRetry: () -> Void

    @State private var hasAttemptedAuthentication = false

    var body: some View {
        ZStack {
            // Hintergrund
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.4), Color(red: 0.1, green: 0.1, blue: 0.15)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Image("nebuliton_card")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .shadow(radius: 20)

                if hasAttemptedAuthentication && authenticationFailed {
                    VStack(spacing: 12) {
                        Text("Face ID / Touch ID konnte dich nicht verifizieren.")
                            .font(.footnote)
                            .foregroundColor(.gray)

                        Button(action: {
                            onRetry()
                        }) {
                            Text("🔓 Erneut versuchen")
                                .fontWeight(.medium)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()
                Text("© 2025 Nebuliton")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            .padding()
            .onAppear {
                hasAttemptedAuthentication = true
            }
        }
    }
}
