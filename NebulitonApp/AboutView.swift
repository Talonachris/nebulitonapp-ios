import SwiftUI

struct AboutView: View {
    @State private var tapCount = 0
    @State private var showPelle = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.4), Color(red: 0.1, green: 0.1, blue: 0.15)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {

                    VStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundColor(.purple)
                        Text("Über die Nebuliton App")
                            .font(.title2)
                            .bold()
                        Text("Deine Kommandozentrale für Gameserver – überall & jederzeit.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .padding(.top)

                    Divider()

                    GroupBox(label: Label("App-Infos", systemImage: "info.circle")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Name: Nebuliton App")
                            Text("• Version: 1.0 (Build 17)")
                            Text("• Entwickler: Talonachris")
                            Text("• © 2025 Nebuliton")
                            Text("• Plattformen: iOS, iPadOS, macOS")
                            Text("• Universal App: iPhone, iPad, Mac")
                        }
                        .font(.footnote)
                    }

                    GroupBox(label: Label("Funktionen", systemImage: "gear")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Server starten, stoppen und verwalten")
                            Text("• Live-Status & Statistiken")
                            Text("• Biometrischer Zugriffsschutz (Face ID / Touch ID)")
                            Text("• Direktes Webpanel-Login & API-Key-Verwaltung")
                        }
                        .font(.footnote)
                    }

                    GroupBox(label: Label("Technologien", systemImage: "bolt")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Pterodactyl Panel – volle Serverkontrolle")
                            Text("• UptimeRobot API – Live-Monitoring")
                            Text("• App-Intents & Deeplinks für schnelle Steuerung")
                            Text("• Universal Codebase mit SwiftUI 5")
                            Text("• We <3 technology – weil wir lieben, was wir tun")
                        }
                        .font(.footnote)
                    }

                    GroupBox(label: Label("Sicherheit", systemImage: "lock.shield")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• API-Schlüssel lokal & verschlüsselt gespeichert")
                            Text("• Face ID / Touch ID zur Authentifizierung")
                            Text("• Keine Cloud – volle Datenhoheit bei dir")
                            Text("• Keine Weitergabe an Dritte, keine Tracker")
                        }
                        .font(.footnote)
                    }

                    GroupBox(label: Label("Hinweis", systemImage: "exclamationmark.triangle")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Diese App ist exklusiv für unsere Kunden.")
                            Text("Eine Nutzung ist nur mit einem aktiven Nebuliton-Gamingserver möglich.")
                        }
                        .font(.footnote)
                    }

                    VStack(spacing: 2) {
                        Text("✨ Powered by Nebuliton")
                            .font(.callout)
                            .bold()
                            .onTapGesture {
                                tapCount += 1
                                if tapCount >= 3 {
                                    showPelle = true
                                    tapCount = 0
                                }
                            }

                        Text("Serverschmiede der Galaxien")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom)
                }
                .padding()
            }
        }
        .navigationTitle("Info")
        .sheet(isPresented: $showPelle) {
            VStack(spacing: 12) {
                Image("pelle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 12)

                Text("🐾 Pelle – Hüter der Galaxien")
                    .font(.title3)
                    .bold()

                Text("Nur die würdigsten Entdecker dürfen ihn sehen.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Button("🛸 Zurück zur App") {
                    showPelle = false
                }
                .padding(.top)
            }
            .padding()
        }
    }
}
