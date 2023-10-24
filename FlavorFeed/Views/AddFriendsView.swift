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
    @State private var selectedOption = "Suggestions"
    var options = ["Suggestions", "Friends", "Requests"]
    @State private var searchText = "Add or search friends"

    var body: some View {
        ZStack {
            VStack {
                Text("Flavor Feed")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, -10)
                NavigationStack {
                    //Text("\(searchText)")
                }
                .searchable(text: $searchText)
                .frame(height: 100)

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

                ScrollView {
                    UserListView()
                }

                //Spacer() // Add this Spacer to push the Picker to the bottom

                Picker("Tabs", selection: $selectedOption) {
                    Text(options[0]).tag(options[0])
                    Text(options[1]).tag(options[1])
                    Text(options[2]).tag(options[2])
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .menuStyle(.borderlessButton)
                Spacer()
            }
        }
    }
}

#Preview {
    AddFriendsView()
}
