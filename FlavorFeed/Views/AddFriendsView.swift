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
    @State private var searchText = "Add or search friends"

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
            VStack {
                Text("FlavorFeed")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, -10)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.black)
                        VStack {
                            Text("Invite friends on Flavor Feed")
                                .foregroundColor(.black)
                            Text("flavor.feed/anonymous")
                                .foregroundColor(.black)
                        }
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.black)
                    }
                    .frame(width: 350)
                }
                .background(Color.ffTertiary)
                .buttonStyle(.bordered)
                .cornerRadius(25)
                .padding(5)
                
                // Separate ZStack for Picker and ScrollView
                
                
                ZStack {
                    UserListView()
                    
                    VStack {
                        Spacer()
                        Picker("Tabs", selection: $selectedOption) {
                            Text(options[0]).tag(options[0])
                            Text(options[1]).tag(options[1])
                            Text(options[2]).tag(options[2])
                        }
                        .pickerStyle(.segmented)
                        .padding(10)
                        .menuStyle(.borderlessButton)
                        .frame(maxWidth: geometry.size.width - 50)
                        //.background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 15)
                    }
                }
            }
            .toolbar {
                    Button {
                        self.tabSelection = .mainScrollView
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                            .font(.system(size: 20)).padding(5)
                    }
                }
            }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    }


#Preview {
    AddFriendsView(tabSelection: Binding.constant(Tabs.addFriendsView))
}
