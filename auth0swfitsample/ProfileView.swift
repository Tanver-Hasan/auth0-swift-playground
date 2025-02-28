//
//  ProfileView.swift
//  auth0swfitsample
//
//  Created by Tanver Hasan on 28/02/2025.
//
import SwiftUI

struct ProfileView: View {
    let user: User
    let logout: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(user.name)
                .font(.title)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                ProfileRow(label: "ID", value: user.id)
                ProfileRow(label: "Email", value: user.email ?? "No Email")
                ProfileRow(label: "Email Verified?", value: user.emailVerified)
                ProfileRow(label: "Updated At", value: user.updatedAt)
            }
            .padding()

            Spacer()

            Button( "Logout ",action: logout)
        }
        .padding()
    }
}

// ✅ Helper View for Profile Info Display
struct ProfileRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .bold()
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}
