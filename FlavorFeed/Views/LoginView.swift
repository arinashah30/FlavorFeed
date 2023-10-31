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
            Spacer().frame(height:100)
            Image("flavorfeed_logo_alt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 340, height:34)
            Spacer().frame(height:50)
            Text("Welcome Back!")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Login to your account")
                .foregroundColor(.white)
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
            .padding([.leading, .trailing, .top])
            
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

            HStack{
                HStack {
                    Button { isChecked.toggle() } label: {
                        isChecked ? Image(systemName: "checkmark.circle.fill").resizable() : Image(systemName: "circle").resizable()
                    }

                    .buttonStyle(.plain)
                    .foregroundColor(Color.ffTertiary)
                    .frame(width:25,height:25)
                    
                    Text("Remember me")
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                                
                Button {
                    
                } label: {
                    Text("Forgot Password?")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(maxWidth: .infinity)
            .padding([.bottom, .leading, .trailing])
            
            
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
                    .bold()
                    .font(.title3)
                    .foregroundStyle(Color.ffSecondary)
            }
            .padding()
            .frame(maxWidth: 140)
            .background(Color.ffTertiary)
            .clipShape(.rect(cornerRadius: 50.0))
            .padding()
                        
            Spacer().frame(height: 200)
            
            HStack {
                Text("Don't have an account?")
                    .foregroundStyle(Color.white)
                
                NavigationLink {
                    SignupView(vm: vm)
                } label: {
                    Text("Sign up")
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
    LoginView(vm: ViewModel())
}
