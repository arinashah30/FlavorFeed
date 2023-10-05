//
//  SignupView.swift
//  FlavorFeed
//
//  Created by Jimmy Pham on 10/5/23.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()
            Text("Create your account")
            
            HStack {
                Image(systemName: "person.fill")
                TextField("", text: Binding.constant(""), prompt: Text("Username"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 7.0))
            .padding([.leading, .trailing, .top])
            
            HStack {
                Image(systemName: "envelope.fill")
                TextField("", text: Binding.constant(""), prompt: Text("Email Address"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 7.0))
            .padding([.leading, .trailing])

            HStack {
                Image(systemName: "lock.fill")
                SecureField("", text:  Binding.constant(""), prompt: Text("Password"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            HStack {
                Image(systemName: "lock.fill")
                SecureField("", text:  Binding.constant(""), prompt: Text("Confirm password"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            HStack {
                Image(systemName: "phone.fill")
                SecureField("", text:  Binding.constant(""), prompt: Text("Phone number"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            HStack {
                Image(systemName: "person.crop.rectangle")
                SecureField("", text:  Binding.constant(""), prompt: Text("Display name"))
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 8.0))
            .padding([.leading, .trailing])
            
            
            Button {
                
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
                    SignupView()
                } label: {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
