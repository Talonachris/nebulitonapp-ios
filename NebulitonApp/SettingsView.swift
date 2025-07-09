import SwiftUI

struct SettingsView: View {
    @State private var useBiometrics = UserDefaults.standard.bool(forKey: "useBiometricLock")

    var body: some View {
        ZStack {
            // Vollflächiger Hintergrund für iPad & Mac
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.4), Color(red: 0.1, green: 0.1, blue: 0.15)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    
                    SettingsCard {
                        Text("Sicherheit")
                            .sectionTitle()

                        Toggle("Face ID / Gerätecode aktivieren", isOn: $useBiometrics)
                            .onChange(of: useBiometrics) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "useBiometricLock")
                            }

                        Text("Bei App-Start oder Rückkehr wird Face ID oder dein Gerätecode benötigt.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    SettingsCard {
                        Text("Server-Verbindung")
                            .sectionTitle()

                        NavigationLink(destination: ServerSettingsView()) {
                            Label("Server verbinden", systemImage: "link")
                                .foregroundColor(.white)
                        }
                    }

                    SettingsCard {
                        Text("Unsere Apps")
                            .sectionTitle()

                        NavigationLink(destination: OurAppsView()) {
                            Label("Unsere Apps", systemImage: "app.badge")
                                .foregroundColor(.white)
                        }
                    }

                    SettingsCard {
                        Text("Über")
                            .sectionTitle()

                        NavigationLink(destination: AboutView()) {
                            Label("Über die App", systemImage: "sparkles")
                                .foregroundColor(.white)
                        }
                    }

                    SettingsCard {
                        Text("Social")
                            .sectionTitle()

                        Group {
                            Link("🌐 Discord", destination: URL(string: "https://discord.gg/SGYH8VfGgF")!)
                            Link("▶️ YouTube", destination: URL(string: "https://www.youtube.com/@nebuliton")!)
                            Link("📸 Instagram", destination: URL(string: "https://www.instagram.com/nebuliton")!)
                            Link("🎶 TikTok", destination: URL(string: "https://www.tiktok.com/@nebuliton")!)
                        }
                        .foregroundColor(.white)
                    }

                    SettingsCard {
                        Text("Rechtliches")
                            .sectionTitle()

                        Group {
                            Link("📜 Nebuliton AGB", destination: URL(string: "https://nebuliton.de/agbmobile")!)
                            Link("🔒 Nebuliton Datenschutz", destination: URL(string: "https://nebuliton.de/datenschutzmobile")!)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(maxWidth: 700) // optional für schönere iPad-Darstellung
            }
        }
        .navigationTitle("Einstellungen")
    }
}

// MARK: - Wiederverwendbare SettingsCard
struct SettingsCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .frame(maxWidth: 600)
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
        )
        .shadow(color: Color.purple.opacity(0.2), radius: 10)
    }
}

// MARK: - Style für Überschriften
extension Text {
    func sectionTitle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.gray)
    }
}
