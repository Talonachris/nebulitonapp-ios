import SwiftUI

struct ServerSettingsView: View {
    @State private var apiKey: String = ""
    @State private var selectedServerId: String = ""
    @State private var serverList: [(name: String, id: String)] = []
    @State private var saved = false
    @State private var testResult: String? = nil

    let sharedDefaults = UserDefaults(suiteName: "group.io.nebuliton.shared")

    var body: some View {
        ZStack {
            // Hintergrund-Gradient über ganze Fläche
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.4), Color(red: 0.1, green: 0.1, blue: 0.15)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    SettingsCard {
                        Text("API-Key & Server")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("ℹ️ Der gewählte Server wird in der gesamten App verwendet – z. B. in Widgets, dem Dashboard oder im Serverstatus.")
                            .font(.caption)
                            .foregroundColor(.gray)

                        TextField("Pterodactyl API-Key", text: $apiKey)
                            .textContentType(.none)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
    #if os(iOS)
                            .autocapitalization(.none)
    #endif

                        Button(action: loadServers) {
                            Label("Serverliste laden", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        if !serverList.isEmpty {
                            Picker("Server auswählen", selection: $selectedServerId) {
                                ForEach(serverList, id: \.id) { server in
                                    Text(server.name).tag(server.id)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        Button(action: saveData) {
                            Label("Speichern", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        if saved {
                            Text("✅ Gespeichert")
                                .font(.caption)
                                .foregroundColor(.green)
                        }

                        Button(action: testServerConnection) {
                            Label("Verbindung testen", systemImage: "checkmark.shield")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        if let result = testResult {
                            Text(result)
                                .font(.caption)
                                .foregroundColor(result.contains("✅") ? .green : .red)
                        }
                    }

                    SettingsCard {
                        Text("Wie finde ich den API-Key?")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("""
                        1. Öffne https://panel.nebuliton.io  
                        2. Melde dich an  
                        3. Klicke oben rechts auf deinen Namen → Konto  
                        4. Gehe zu „API“  
                        5. Erstelle dort einen neuen Schlüssel und kopiere ihn hier rein
                        """)
                        .font(.caption)
                        .foregroundColor(.gray)
                    }

                    // Puffer am unteren Ende gegen schwarzen Balken
                    Color.clear.frame(height: 60)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Server verbinden")
        .onAppear {
            apiKey = sharedDefaults?.string(forKey: "apiKey") ?? ""
            selectedServerId = sharedDefaults?.string(forKey: "serverId") ?? ""
        }
    }

    // MARK: - Save
    func saveData() {
        sharedDefaults?.set(apiKey, forKey: "apiKey")
        sharedDefaults?.set(selectedServerId, forKey: "serverId")

        if let selectedName = serverList.first(where: { $0.id == selectedServerId })?.name {
            sharedDefaults?.set(selectedName, forKey: "serverName")
        }

        saved = true
        testResult = nil
    }

    // MARK: - Serverliste laden
    func loadServers() {
        guard let url = URL(string: "https://panel.nebuliton.io/api/client") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataArray = json["data"] as? [[String: Any]] else {
                return
            }

            let servers = dataArray.compactMap { item -> (String, String)? in
                guard let attributes = item["attributes"] as? [String: Any],
                      let name = attributes["name"] as? String,
                      let id = attributes["identifier"] as? String else {
                    return nil
                }
                return (name, id)
            }

            DispatchQueue.main.async {
                serverList = servers
            }
        }.resume()
    }

    // MARK: - Verbindung testen
    func testServerConnection() {
        guard let url = URL(string: "https://panel.nebuliton.io/api/client/servers/\(selectedServerId)/resources") else {
            testResult = "❌ Ungültige URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                    testResult = "✅ Verbindung erfolgreich – Server antwortet"
                } else {
                    testResult = "❌ Verbindung fehlgeschlagen – API-Key oder Auswahl prüfen"
                }
            }
        }.resume()
    }
}
