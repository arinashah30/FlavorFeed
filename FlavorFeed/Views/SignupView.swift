//
//  SignupView.swift
//  FlavorFeed
//
//  Created by Jimmy Pham on 10/5/23.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var vm: ViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword = ""
    @State private var username: String = ""
    @State private var displayName: String = ""
    @State private var phoneNumber = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()
            Text("Create your account")
            
            HStack {
                Image(systemName: "person.fill")
                TextField("", text: $username, prompt: Text("Username"))
                    .textInputAutocapitalization(.never)

            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 7.0))
            .padding([.leading, .trailing, .top])
            
            HStack {
                Image(systemName: "envelope.fill")
                TextField("", text: $email, prompt: Text("Email Address"))
                    .textInputAutocapitalization(.never)

            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 7.0))
            .padding([.leading, .trailing])

            HStack {
                Image(systemName: "lock.fill")
                SecureField("", text:  $password, prompt: Text("Password"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            HStack {
                Image(systemName: "lock.fill")
                SecureField("", text:  $repeatPassword, prompt: Text("Confirm password"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            HStack {
                Image(systemName: "phone.fill")
                TextField("", text: $phoneNumber, prompt: Text("Phone Number"))
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            HStack {
                Image(systemName: "person.crop.rectangle")
                TextField("", text: $displayName, prompt: Text("Display Name"))
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            if let errorText = vm.errorText {
                Text(errorText).foregroundStyle(Color.red)
            } else {
                Text(" ")
            }
            
            Button {
                vm.errorText = nil
                email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                repeatPassword = repeatPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                phoneNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)

                if !email.isEmpty && !username.isEmpty && !displayName.isEmpty && !phoneNumber.isEmpty && !password.isEmpty && password == repeatPassword {
                    vm.firebase_email_password_sign_up(
                        email: self.email,
                        password: self.password,
                        username: self.username,
                        displayName: self.displayName,
                        phoneNumber: self.phoneNumber
                    )
                } else {
                    vm.errorText = "You must fill out all fields"
                }
            } label: {
                Text("SIGN UP")
                    .font(.title3)
                    .foregroundStyle(Color.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 50.0))
            .padding()
                        
            HStack {
                Text("Already have an account?")
                
                NavigationLink {
                    LoginView(vm: vm)
                } label: {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
            }
        }
        .onAppear {
            vm.errorText = nil
        }
    }
}

#Preview {
    SignupView(vm: ViewModel())
}
