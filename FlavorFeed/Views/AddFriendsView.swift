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
    @State private var requests: [Friend] = [Friend]()
    @State private var suggestions: [Friend] = [Friend]()
    @State private var friends: [Friend] = [Friend]()
        
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        HStack {
                            //Spacer(minLength: UIScreen.main.bounds.size.width / 4).padding(.leading, 5)
                            Spacer()
                            
                            //Spacer(minLength: UIScreen.main.bounds.size.width / 5)
                            Button {
                                self.tabSelection = .mainScrollView
                            } label: {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20)).padding(5)
                            }.padding(.trailing, 5)
                        }
                        Image("flavorfeed_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:  18.3)
                            .offset(x: 0)
                    }
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
                    
                   
                        
                    UserListView(vm: vm, suggestions: $suggestions, friends: $friends, requests: $requests, searchText: $searchText, selectedOption: $selectedOption)

                        
                        
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
                    
                
                

            }
        }
        .onAppear {
            UISegmentedControl.appearance().backgroundColor = .white
            vm.get_friend_requests() { friends in
                requests = friends
            }
            vm.get_friend_suggestions() { friends in
                suggestions = friends
            }
            vm.get_friends_ids() { friendIDs in
                vm.get_friends(userIDs: friendIDs) { friend in
                    friends = friend
                }
            }
        }
    }

}

//can remove this function once we have users list from firebase


#Preview {
    AddFriendsView(tabSelection: Binding.constant(Tabs.addFriendsView), vm: ViewModel())
}
