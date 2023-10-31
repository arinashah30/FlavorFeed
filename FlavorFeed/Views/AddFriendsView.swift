//
//  AddFriendsView.swift
//  FlavorFeed
//
//  Created by Misry Dhanani, Husna Jakeer, Subha Udhyakumar, and Triem Le on 10/12/23.
//

import SwiftUI

struct Person {
    var name: String
}

struct AddFriendsView: View {
    @Binding var tabSelection: Tabs
    @State private var selectedOption = "Suggestions"
    var options = ["Suggestions", "Friends", "Requests"]
    @State private var searchText = ""
    //@FocusState private var emailFieldIsFocused: Bool = false
    @ObservedObject var vm: ViewModel
    var users: [User] = addUsers() //later this will be the list of users we load in from firebase available in the view model
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    TextField("Add or search friends",text: $searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .border(.secondary)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50, alignment: .leading)
                                .foregroundColor(.black)
                            VStack (alignment: .leading) {
                                Text("Invite friends on Flavor Feed")
                                    .foregroundColor(.black)
                                Text("flavor.feed/anonymous")
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Button(action: {}, label: {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30, alignment: .trailing)
                                    .foregroundColor(Color.ffPrimary)
                            })
                            
                        }.padding(5)
                            .frame(width: 350, height: 50)
                    }
                    .background(Color.ffTertiary)
                    .buttonStyle(.bordered)
                    .cornerRadius(25)
                    .padding(.top, 50)
                    
                    // Separate ZStack for Picker and ScrollView
                    
                   
                        
                        UserListView(users: users, searchText: $searchText)
//                            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Add or search friends")
                        
                        
                            Spacer()
                            Picker("Tabs", selection: $selectedOption) {
                                Text(options[0]).tag(options[0])
                                Text(options[1]).tag(options[1])
                                Text(options[2]).tag(options[2])
                            }
                            .pickerStyle(.segmented)
                            .padding(.bottom, 30)
                            .menuStyle(.borderlessButton)
                            .frame(width: geometry.size.width - 50)
                        }
                    
                
                
                .toolbar {
                    HStack {
                        Spacer()
                        Image("flavorfeed_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:  18.3)
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button {
                            self.tabSelection = .mainScrollView
                        } label: {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .font(.system(size: 20)).padding(5)
                        }
                    }.padding([.leading, .trailing])
                }
            }
        }
        .onAppear {
            UISegmentedControl.appearance().backgroundColor = .white
        }
    }
}

//can remove this function once we have users list from firebase
func addUsers() -> [User] {
    var users : [User] = []
    for i in 1...30 {
        let user = User(id: "name\(i)", name: "name\(i)", username: "userName\(i)", profilePicture: "self_profile_view_icon", email: "", favorites: [], friends: [], savedPosts: [], bio: "", myPosts: [], phoneNumber: 0, location: "", myRecipes: [])
        users.append(user)
    }
    return users
}


#Preview {
    AddFriendsView(tabSelection: Binding.constant(Tabs.addFriendsView), vm: ViewModel())
}
