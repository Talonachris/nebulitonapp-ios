import SwiftUI

// Datenmodell für eine App
struct AppInfo: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
    let appStoreURL: URL
}

// Die eigentliche View mit allen Apps
struct OurAppsView: View {
    let apps: [AppInfo] = [
        AppInfo(
            iconName: "pulseview_icon",
            title: "PulseView",
            description: "Die inoffizielle Companion-App für WhatPulse. Zeigt deine Tastenanschläge, Klicks, Bandbreite & mehr – mit Stil.",
            appStoreURL: URL(string: "https://apps.apple.com/app/id6469403895")!
        )
    ]

    var body: some View {
        ZStack {
            // Fix: Hintergrund-Gradient über gesamte Fläche
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.4), Color(red: 0.1, green: 0.1, blue: 0.15)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    Text("Unsere Apps")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top)

                    ForEach(apps) { app in
                        AppCardView(app: app)
                            .frame(maxWidth: 600)
                    }

                    // 🧼 Spacer, der sicherstellt, dass auch der untere Bereich gut aussieht
                    Color.clear
                        .frame(height: 60)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// Einzelne App-Karte
struct AppCardView: View {
    let app: AppInfo

    var body: some View {
        VStack(spacing: 16) {
            Image(app.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.purple.opacity(0.5), radius: 10)

            Text(app.title)
                .font(.title2.bold())
                .foregroundColor(.white)

            Text(app.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Button(action: {
                UIApplication.shared.open(app.appStoreURL)
            }) {
                Text("Im App Store ansehen")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(radius: 6)
    }
}
