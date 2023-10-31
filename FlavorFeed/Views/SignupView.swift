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
            Spacer().frame(height:100)
            Image("flavorfeed_logo_alt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 340, height:34)
            Text("Sign Up")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Create your account")
                .foregroundColor(.white)
            
            
            
            HStack {
                Image("signup_user_icon")
                    .resizable()
                    .frame(width:35,height:35)
                    .padding(.leading)
                HStack {
                    TextField("", text: $username, prompt: Text("Username")                .foregroundColor(.white))
                        .textInputAutocapitalization(.never)
                }
                .padding()
                .background(Color.ffPrimary)
                .clipShape(.rect(cornerRadius: 7.0))
                .padding()
            }
            .padding([.leading, .trailing, .top])
            .padding(.bottom, -15)
            
            HStack {
                Image("email_icon")
                    .resizable()
                    .frame(width:35,height:30)
                    .padding(.leading)
                HStack {
                    TextField("", text: $email, prompt: Text("Email")                .foregroundColor(.white))
                        .textInputAutocapitalization(.never)
                }
                .padding()
                .background(Color.ffPrimary)
                .clipShape(.rect(cornerRadius: 7.0))
                .padding()
            }
            .padding([.leading, .trailing])
            
            HStack {
                Image("password_icon")
                    .resizable()
                    .frame(width:35, height: 20)
                    .padding(.leading)
                HStack {
                    SecureField("", text:  $password, prompt: Text("Password")
                        .foregroundColor(.white))
                }
                .padding()
                .background(Color.ffPrimary)
                .clipShape(.rect(cornerRadius: 8.0))
                .padding([.leading, .trailing])
            }
            .padding([.leading, .trailing, .bottom])
            
            HStack {
                Image("password_icon")
                    .resizable()
                    .frame(width:35, height: 20)
                    .padding(.leading)
                HStack {
                    SecureField("", text:  $repeatPassword, prompt: Text("Confirm Password")
                        .foregroundColor(.white))
                }
                .padding()
                .background(Color.ffPrimary)
                .clipShape(.rect(cornerRadius: 8.0))
                .padding([.leading, .trailing])
            }
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
                
                if !email.isEmpty && !username.isEmpty && !displayName.isEmpty && !phoneNumber.isEmpty && !password.isEmpty && password == repeatPassword {
                    vm.firebase_email_password_sign_up(
                        email: self.email,
                        password: self.password,
                        username: self.username,
                        displayName: self.displayName,
                        phoneNumber: self.phoneNumber
                    )
                }
                else {
                    vm.errorText = "You must fill out all fields"
                }
            } label: {
                Text("SIGN UP")
                    .bold()
                    .font(.title3)
                    .foregroundStyle(Color.ffSecondary)
            }
            .padding()
            .frame(maxWidth: 140)
            .background(Color.ffTertiary)
            .clipShape(.rect(cornerRadius: 50.0))
                        
            Spacer().frame(height: 150)
            
            HStack {
                Text("Already have an account?")
                    .foregroundStyle(Color.white)
                
                NavigationLink {
                    LoginView(vm: vm)
                } label: {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.ffTertiary)
                }
            }
        }
        .onAppear {
            vm.errorText = nil
        }
        .background(
            Image("onboarding_background")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
        )
    }
}

#Preview {
    SignupView(vm: ViewModel())
}
