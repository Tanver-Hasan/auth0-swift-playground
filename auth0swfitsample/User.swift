//
//  User.swift
//  auth0swfitsample
//
//  Created by Tanver Hasan on 28/02/2025.
//
import JWTDecode

struct User {
    let id: String
    let name: String
    let email: String?
    let emailVerified: String
    let picture: String?
    let updatedAt: String
}

extension User {
    init?(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken),
              let id = jwt.subject,
              let name = jwt["name"].string,
              let emailVerified = jwt["email_verified"].boolean,
              let updatedAt = jwt["updated_at"].string else {
            print("❌ Failed to decode JWT token.")
            return nil
        }

        self.id = id
        self.name = name
        self.email = jwt["email"].string // ✅ Optional
        self.emailVerified = String(describing: emailVerified)
        self.picture = jwt["picture"].string // ✅ Optional
        self.updatedAt = updatedAt

        // ✅ Log Decoded Token Information
        print("🔓 Decoded JWT Token:")
        print("🆔 ID: \(self.id)")
        print("👤 Name: \(self.name)")
        print("📧 Email: \(self.email ?? "No Email")")
        print("✅ Email Verified: \(self.emailVerified)")
        print("🖼 Profile Picture URL: \(self.picture ?? "No Profile Picture")")
        print("⏳ Updated At: \(self.updatedAt)")
    }
}
