import SwiftUI

struct ContentView: View {
    #if os(macOS)
    @State private var selectedTab = 0
    #endif

    var body: some View {
        #if os(macOS)
        VStack(spacing: 0) {
            Picker("Navigation", selection: $selectedTab) {
                Text("Start").tag(0)
                Text("Panel").tag(1)
                Text("Status").tag(2)
                Text("Einstellungen").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Divider()

            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: WebView(url: "https://panel.nebuliton.io")
                case 2: WebView(url: "https://status.nebuliton.de")
                case 3: SettingsView()
                default: HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 720, minHeight: 540)
        #else
        TabView {
            HomeView()
                .tabItem {
                    Label("Start", systemImage: "house.fill")
                }

            WebView(url: "https://panel.nebuliton.io")
                .tabItem {
                    Label("Panel", systemImage: "server.rack")
                }

            WebView(url: "https://status.nebuliton.de")
                .tabItem {
                    Label("Status", systemImage: "waveform.path.ecg")
                }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Einstellungen", systemImage: "gearshape.fill")
            }
        }
        #endif
    }
}
