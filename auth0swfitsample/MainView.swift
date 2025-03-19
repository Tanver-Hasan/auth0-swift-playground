//
//  MainView.swift
//  auth0swfitsample
//
//  Created by Tanver Hasan on 28/02/2025.
//
import SwiftUI
import Auth0
import AuthenticationServices

struct MainView: View {
    @State private var user: User?
    @State private var isAuthenticated: Bool = false
    
    private var credentialsManager: CredentialsManager
    
      init() {
            self.credentialsManager = CredentialsManager(authentication: Auth0.authentication())
//            self.credentialsManager.enableBiometrics(withTitle: "Unlock with Face ID or passcode",
//                                                     evaluationPolicy: .deviceOwnerAuthentication)
        }

    var body: some View {
        Group {
            if isAuthenticated{
                VStack{
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                    Text("Checking Session...")
                        .font(.headline)
                        .padding()
                }
            }
            else if let user=user {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }

                    ContentView()
                        .tabItem {
                            Label("Content", systemImage: "doc.text.fill")
                        }

                    ProfileView(user: user,logout: clearLocalSession)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                   
                }
            } else {
               
                VStack {
                    Text("Welcome to the App")
                        .font(.largeTitle)
                        .padding()

                    ULPLoginButton(action: login)
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.email, .fullName]
                        },
                        onCompletion: handleSignInWithApple
                    ).frame(width: 350, height: 44, alignment: .center)
                        .cornerRadius(20)
                    
                }
                .padding()
            }
        }.onAppear{
            checkForStoredCredentials()
        }

    }
    func checkForStoredCredentials() {
           print("🔍 Checking stored credentials...")

           if credentialsManager.canRenew() {
               credentialsManager.credentials { result in
                   DispatchQueue.main.async {
                       switch result {
                       case .success(let credentials):
                           print("✅ Credentials found, auto-logging in...")
                           self.user = User(from: credentials.idToken)
                       case .failure(let error):
                           print("❌ Failed to retrieve credentials: \(error.localizedDescription)")
                       }
                       self.isAuthenticated = false
                   }
               }
           } else {
               print("⚠️ No renewable credentials, showing login screen.")
               self.isAuthenticated = false
           }
       }


    func login() {
        print("🔐 Starting Auth0 Login...")
        Auth0
            .webAuth()
            .logging(enabled: true)
            .useHTTPS()
            .audience("https://api.acme.com/api/v1")
            .scope("openid profile email offline_access")
            .start { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let credentials):
                        print("✅ Login Successful!")
                        print("Credentials: \(credentials)")
                        print("ID token: \(credentials.idToken)")
                        print("Access token: \(credentials.accessToken)")
                        print("Refresh token: \(credentials.refreshToken ?? "")")
                        
                        credentialsManager.store(credentials: credentials)
                        self.user = User(from: credentials.idToken)
                        
                    case .failure(let error):
                        print("❌ Login Failed: \(error.localizedDescription)")
                    }
                }
            }
    }

    func logout() {
        print("🔓 Logging out...")
        credentialsManager.clear()
        
        Auth0
            .webAuth()
            .logging(enabled: true)
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
    func clearLocalSession() {
        print("🔓 Logging out...")
      
      let didClear =  credentialsManager.clear()
        if didClear{
            DispatchQueue.main.async {
                print("✅ Logout Successful!")
                self.user = nil
                self.isAuthenticated=false
            }
        }else{
            print( "❌ Logout Failed: Could not clear local session.")
        }
    }
    
    func handleSignInWithApple(result:Result<ASAuthorization, any Error> ) {
        switch result {
        case .success(let auth):
            guard let credential = auth.credential as? ASAuthorizationAppleIDCredential else {
                return
            }
            let idToken=credential.identityToken
            
            let tokeString = idToken != nil ? String(data: idToken!, encoding: .utf8) : nil
            guard let appleIdToken = tokeString else {
                print( "❌ Failed to obtain Apple ID Token")
                return
            }
            print("Apple ID Token : "+appleIdToken);
            
            if let authorizationCodeData = credential.authorizationCode,
               let authCodeString = String(data: authorizationCodeData, encoding: .utf8) {
                print( " Apple Authorization Code: \(authCodeString)")
                Auth0.authentication()
                    .login(appleAuthorizationCode: authCodeString, scope: "openid profile email offline_access")
                    .start { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let credentials):
                                print("Credentials: \(credentials)")
                                print("ID token: \(credentials.idToken)")
                                print("Access token: \(credentials.accessToken)")
                                print("Refresh token: \(credentials.refreshToken ?? "")")
                                
                                credentialsManager.store(credentials: credentials)
                                self.user = User(from: credentials.idToken)
                            case .failure(let error):
                                print("❌ Token Exchange Failed: \(error.localizedDescription)")
                            }
                        }
                    }
            }
            case .failure(let error):
                print("❌ Apple Sign-In Failed: \(error.localizedDescription)")
            
        }
    }
}


struct ULPLoginButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "person.fill")
                    .font(.title2)
                Text("Login with ULP")
                    .fontWeight(.semibold)
            }
            .frame(width: 350, height:  44)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal, 16)
        }
    }
}




//#Preview {
//    MainView()
//}
