import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let webUrl = URL(string: url) {
            uiView.load(URLRequest(url: webUrl))
        }
    }
}
