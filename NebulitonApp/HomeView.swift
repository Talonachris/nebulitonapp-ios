import SwiftUI

struct HomeView: View {
    @ObservedObject var stats = ServerStatsFetcher()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.12, green: 0.09, blue: 0.2),
                        Color(red: 0.18, green: 0.1, blue: 0.27)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        headerSection
                        infoSection
                        if stats.isConfigured {
                            statsSection
                        }
                        footerNote
                    }
                    .padding()
                }
            }
            .navigationTitle("Start")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { stats.startFetching() }
        .onDisappear { stats.stopFetching() }
    }

    private var headerSection: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 180, height: 180)
                    .blur(radius: 24)

                PulseCircleView(icon: "bolt.fill", color: .purple, size: 180)
                    .frame(width: 100, height: 100)

                Image("NebulitonLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .purple.opacity(0.5), radius: 14, x: 0, y: 6)
            }

            Text("Willkommen bei Nebuliton")
                .font(.title2).bold()
                .foregroundColor(.white)
                .padding(.top, 16)

            Text("Dein Dashboard für Serverstatus, Verwaltung, Sicherheit und mehr.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    private var infoSection: some View {
        VStack(spacing: 12) {
            Divider().background(Color.white.opacity(0.1))
            Text("⚙️ Deine Steuerzentrale für:")
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 16) {
                Label("Server-Status", systemImage: "waveform.path.ecg")
                Label("Panel-Zugriff", systemImage: "server.rack")
            }
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        }
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🌐 Aktueller Serverstatus")
                .font(.headline)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                Text("CPU: \(String(format: "%.1f", stats.cpuUsage)) %")
                Text("RAM: \(stats.memoryUsageGB) GB")
                Text("Speicher: \(stats.diskUsageGB) GB")
                Text("Uptime: \(stats.uptimeFormatted)")
                Text("Letzte Aktualisierung: \(stats.lastUpdated.formatted(date: .omitted, time: .standard))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .purple.opacity(0.3), radius: 10)
        }
    }

    private var footerNote: some View {
        VStack(spacing: 8) {
            Divider().background(Color.white.opacity(0.1))
            Text("👉 Tippe unten auf 'Panel' oder 'Status', um loszulegen!")
                .font(.footnote)
                .foregroundColor(.gray)

            Text("© 2025 Nebuliton")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
    }
}
