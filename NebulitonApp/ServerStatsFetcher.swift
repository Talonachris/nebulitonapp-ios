import Foundation
import Combine

class ServerStatsFetcher: ObservableObject {
    @Published var cpuUsage: Double = 0.0
    @Published var memoryUsage: Int = 0
    @Published var memoryTotal: Int = 1
    @Published var diskUsage: Int = 0
    @Published var diskTotal: Int = 1
    @Published var uptimeFormatted: String = ""
    @Published var lastUpdated: Date = Date()
    @Published var isConfigured: Bool = false

    private var timer: Timer?
    private let defaults = UserDefaults(suiteName: "group.io.nebuliton.shared")

    func startFetching() {
        fetchStats()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.fetchStats()
        }
    }

    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }

    private func fetchStats() {
        guard let apiKey = defaults?.string(forKey: "apiKey"),
              let serverId = defaults?.string(forKey: "serverId") else {
            isConfigured = false
            return
        }

        let url = URL(string: "https://panel.nebuliton.io/api/client/servers/\(serverId)/resources")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let attributes = (json["attributes"] as? [String: Any])?["resources"] as? [String: Any] else {
                return
            }

            DispatchQueue.main.async {
                self.cpuUsage = attributes["cpu_absolute"] as? Double ?? 0
                self.memoryUsage = attributes["memory_bytes"] as? Int ?? 0
                self.memoryTotal = max(attributes["memory_limit_bytes"] as? Int ?? 1, 1)
                self.diskUsage = attributes["disk_bytes"] as? Int ?? 0
                self.diskTotal = max(attributes["disk_limit_bytes"] as? Int ?? 1, 1)

                let uptimeMilliseconds = attributes["uptime"] as? Int ?? 0
                let uptimeSeconds = uptimeMilliseconds / 1000
                self.uptimeFormatted = self.formatUptime(seconds: uptimeSeconds)

                self.lastUpdated = Date()
                self.isConfigured = true
            }
        }.resume()
    }

    private func formatUptime(seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)s"
        } else if seconds < 3600 {
            return "\(seconds / 60)m"
        } else {
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            return "\(hours)h \(minutes)m"
        }
    }

    var memoryUsageGB: String {
        String(format: "%.2f", Double(memoryUsage) / 1_073_741_824)
    }

    var memoryTotalGB: String {
        String(format: "%.2f", Double(memoryTotal) / 1_073_741_824)
    }

    var diskUsageGB: String {
        String(format: "%.2f", Double(diskUsage) / 1_073_741_824)
    }

    var diskTotalGB: String {
        String(format: "%.2f", Double(diskTotal) / 1_073_741_824)
    }
}
