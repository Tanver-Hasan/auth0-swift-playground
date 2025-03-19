//
//  auth0swfitsampleApp.swift
//  auth0swfitsample
//
//  Created by Tanver Hasan on 28/02/2025.
//

import SwiftUI

@main
struct auth0swfitsampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
            #if os(iOS)
                .padding(.bottom, 16)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background(Color("Background").ignoresSafeArea())
//               .buttonStyle(PrimaryButtonStyle())
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                    UITableView.appearance().bounces = false
                }
            #else
                .padding(.bottom, 32)
                .frame(maxWidth: 400, maxHeight: 300)
            #endif
        }
    }
}
