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
    @ObservedObject var vm: ViewModel
    var users: [User] = addUsers() //later this will be the list of users we load in from firebase available in the view model
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: 40)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Add or search friends",text: $searchText)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.systemGray5)))
                        .frame(maxWidth: geometry.size.width - 20)
                        .padding(.bottom, 10)
                    
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
                            
                        }.padding(10)
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(Color.ffTertiary).frame(width: 350, height: 60))

                    
                    // Separate ZStack for Picker and ScrollView
                    
                   
                        
                        UserListView(users: users, searchText: $searchText)

                        
                        
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
                    }
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
        var user: User
        if (i % 2 == 0) {
            user = User(id: "champagnepapi", name: "Drake", profilePicture: "drake_pfp", email: "drake@gmail.com", bio: "I'm Drake.", phoneNumber: "1234567890", friends: [], pins: [], myPosts: [])
        } else {
            user = User(id: "travisscott", name: "Travis Scott", profilePicture: "travis_scott_pfp", email: "travisscott@gmail.com", bio: "I'm Travis Scott.", phoneNumber: "1234567890", friends: [], pins: [], myPosts: [])
        }
        
        users.append(user)
    }
    return users
}


#Preview {
    AddFriendsView(tabSelection: Binding.constant(Tabs.addFriendsView), vm: ViewModel())
}
