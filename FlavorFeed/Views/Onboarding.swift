//
//  Onboarding.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/5/23.
//

import SwiftUI

struct Onboarding: View {
    @ObservedObject var vm: ViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword = ""
    @State private var username: String = ""
    @State private var displayName: String = ""
    @State private var phoneNumber = ""
    var body: some View {
        VStack(spacing: 30) {
            TextField("Email Address", text: $email)
            TextField("Username", text: $username)
            TextField("Display Name", text: $displayName)
            TextField("Phone Number", text: $phoneNumber)
            SecureField("Password", text: $password)
            SecureField("Repeat Password", text:$repeatPassword)

            Button {
                email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                repeatPassword = repeatPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)



                if !email.isEmpty && !username.isEmpty && !displayName.isEmpty && !phoneNumber.isEmpty && !password.isEmpty && password == repeatPassword {
                    vm.firebase_email_password_sign_up(
                        email: self.email,
                        password: self.password,
                        username: self.username,
                        displayName: self.displayName,
                        phoneNumber: self.phoneNumber
                    )
                }
            } label: {
                Text("Sign Up")
                
            }
        }
    }
}

#Preview {
    Onboarding(vm: ViewModel())
}
