//
//  LoginView.swift
//  FlavorFeed
//
//  Created by Jimmy Pham on 10/5/23.
//

import SwiftUI

struct LoginView: View {
    @State var isChecked = false

    var body: some View {
        VStack {
            Text("Welcome Back")
                .font(.largeTitle)
                .padding()
            Text("Login to your account")
            
            HStack {
                Image(systemName: "envelope.fill")
                TextField("", text: Binding.constant(""), prompt: Text("Email Address"))
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 7.0))
            .padding()

            HStack {
                Image(systemName: "lock.fill")
                SecureField("", text:  Binding.constant(""), prompt: Text("Password"))
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
            
            Button {
                
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
                    SignupView()
                } label: {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
