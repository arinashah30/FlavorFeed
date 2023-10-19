//
//  LoginView.swift
//  FlavorFeed
//
//  Created by Jimmy Pham on 10/5/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: ViewModel
    @State var isChecked = false
    @State var email = ""
    @State var password = ""

    var body: some View {
        VStack {
            Text("Welcome Back")
                .font(.largeTitle)
                .padding()
            Text("Login to your account")
            
            HStack {
                Image(systemName: "envelope.fill")
                TextField("", text: $email, prompt: Text("Email Address"))
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 7.0))
            .padding()

            HStack {
                Image(systemName: "lock.fill")
                SecureField("", text:  $password, prompt: Text("Password"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])

            HStack{
                HStack {
                    Button { isChecked.toggle() } label: {
                        isChecked ? Image(systemName: "checkmark.square") : Image(systemName: "square")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(Color.gray)
                    
                    Text("Remember me")
                }
                .frame(maxWidth: .infinity)
                                
                Button {
                    
                } label: {
                    Text("Forgot Password?")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(maxWidth: .infinity)
            .padding([.bottom, .leading, .trailing])
            
            Spacer().frame(height: 150)
            
            if let errorText = vm.errorText {
                Text(errorText).foregroundStyle(Color.red)
            } else {
                Text(" ")
            }
            
            Button {
                vm.errorText = nil
                email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !email.isEmpty && !password.isEmpty {
                    vm.firebase_sign_in(email: email, password: password)
                } else {
                    vm.errorText = "You must fill out all fields"
                }
            } label: {
                Text("LOGIN")
                    .font(.title3)
                    .foregroundStyle(Color.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 50.0))
            .padding()
                        
            HStack {
                Text("Don't have an account?")
                
                NavigationLink {
                    SignupView(vm: vm)
                } label: {
                    Text("Sign up")
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
    LoginView(vm: ViewModel())
}
