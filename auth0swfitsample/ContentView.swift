//
//  ContentView.swift
//  auth0swfitsample
//
//  Created by Tanver Hasan on 28/02/2025.
//

import SwiftUI

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


struct ContentView: View {
    @State private var showWebView = false

    var body: some View {
        VStack(spacing: 20) {
            Text("📄 Content Screen")
                .font(.largeTitle)

            Button(action: { showWebView = true }) {
                Text("Sign Agreements")
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showWebView) {
            WebView(url: URL(string: "https://auth0.com")!)
                .ignoresSafeArea()
        }
    }
}

//#Preview {
//    ContentView()
//}
