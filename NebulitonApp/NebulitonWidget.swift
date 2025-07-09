import WidgetKit
import SwiftUI
import Intents

// MARK: - Entry
struct ServerStatusEntry: TimelineEntry {
    let date: Date
    let serverName: String
    let isOnline: Bool
    let lastUpdate: Date
}

// MARK: - API Client
struct APIClient {
    static func fetchServerStatus(completion: @escaping (ServerStatusEntry) -> Void) {
        let defaults = UserDefaults(suiteName: "group.io.nebuliton.shared")
        guard let apiKey = defaults?.string(forKey: "apiKey"),
              let serverId = defaults?.string(forKey: "serverId") else {
            let fallback = ServerStatusEntry(
                date: Date(),
                serverName: "Unbekannt",
                isOnline: false,
                lastUpdate: Date()
            )
            completion(fallback)
            return
        }

        let url = URL(string: "https://panel.nebuliton.io/api/client/servers/\(serverId)/resources")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            let isOnline: Bool
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let attributes = json["attributes"] as? [String: Any],
               let currentState = attributes["current_state"] as? String {
                isOnline = (currentState == "running")
            } else {
                isOnline = false
            }

            let entry = ServerStatusEntry(
                date: Date(),
                serverName: "Server \(serverId.prefix(8))",
                isOnline: isOnline,
                lastUpdate: Date()
            )
            completion(entry)
        }.resume()
    }

    static func sendPowerSignal(_ signal: String) {
        let defaults = UserDefaults(suiteName: "group.io.nebuliton.shared")
        guard let apiKey = defaults?.string(forKey: "apiKey"),
              let serverId = defaults?.string(forKey: "serverId") else {
            return
        }

        let url = URL(string: "https://panel.nebuliton.io/api/client/servers/\(serverId)/power")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["signal": signal])

        URLSession.shared.dataTask(with: request).resume()
    }
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ServerStatusEntry {
        ServerStatusEntry(date: Date(), serverName: "NebulitonMC", isOnline: true, lastUpdate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ServerStatusEntry) -> Void) {
        APIClient.fetchServerStatus { entry in
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ServerStatusEntry>) -> Void) {
        APIClient.fetchServerStatus { entry in
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}
