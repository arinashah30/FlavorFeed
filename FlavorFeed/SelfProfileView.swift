//
//  SelfProfileView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI

struct SelfProfileView: View {
    @ObservedObject var vm: ViewModel
    @Binding var tabSelection: Tabs
    @State private var bio: String = ""
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var username: String = ""
    @State private var isEditing: Bool = false


    func getInformation() {
        vm.getInformation()
        bio = vm.current_user!.bio
        email = vm.current_user!.email
        name = vm.current_user!.name
        phoneNumber = String(vm.current_user!.phoneNumber)
        username = vm.current_user!.username
    }
    
    func saveInfo() {
        vm.updateUser(bio: bio, email: email, name: name, phoneNumber: phoneNumber, username: username)
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    self.tabSelection = .mainScrollView
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 40))
                }
                Spacer()
            }.padding()

            Spacer()

            Text("Self Profile View")
                .font(.largeTitle)

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("Bio:")
                TextField("Your Bio", text: $bio)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
                    .padding()

                Text("Email:")
                TextField("your@email.com", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
                    .padding()

                Text("Name:")
                TextField("Your Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
                    .padding()

                Text("Phone Number:")
                TextField("123-456-7890", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
                    .padding()

                Text("Username:")
                TextField("YourUsername", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditing)
                    .padding()
            }

            Button(action: {
                if isEditing {
                    saveInfo() // Call saveInfo() when "Save" is tapped
                }
                isEditing.toggle() // Toggle the editing mode
            }) {
                Text(isEditing ? "Save" : "Edit")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                getInformation() // Call getInformation() to populate the fields
            }) {
                Text("Load Information")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .onAppear {
            // Load initial information when the view appears
            getInformation()
        }
    }
}

