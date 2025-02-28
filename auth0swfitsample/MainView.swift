//
//  MainView.swift
//  auth0swfitsample
//
//  Created by Tanver Hasan on 28/02/2025.
//
import SwiftUI
import Auth0

struct MainView: View {
    @State private var user: User?

    var body: some View {
        if let user = user {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                ContentView()
                    .tabItem {
                        Label("Content", systemImage: "doc.text.fill")
                    }

                ProfileView(user: user,logout: logout)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
               
            }
        } else {
           
            VStack {
                Text("Welcome to the App")
                    .font(.largeTitle)
                    .padding()

                Button("Login", action: self.login)
                
            }
            .padding()
        }
    }


    func login() {
        print("🔐 Starting Auth0 Login...")
        Auth0
            .webAuth()
            .useHTTPS()
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let credentials):
                        print("✅ Login Successful!")
                        self.user = User(from: credentials.idToken)
                    case .failure(let error):
                        print("❌ Login Failed: \(error.localizedDescription)")
                    }
                }
            }
    }

    func logout() {
        print("🔓 Logging out...")
        Auth0
            .webAuth()
            .useHTTPS()
            .clearSession { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("✅ Logout Successful!")
                        self.user = nil
                    case .failure(let error):
                        print("❌ Logout Failed: \(error.localizedDescription)")
                    }
                }
            }
    }
}





//#Preview {
//    MainView()
//}
