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
            VStack{
                Text("Flavor Feed")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.bottom, -10)
                NavigationStack {
                    //Text("\(searchText)")
                }
                .searchable(text: $searchText)
                .background(Color.ffTertiary)
                Button(action: {}, label: {
                    HStack{
                        Image(systemName: "person.circle")
                        VStack{
                            Text("Invite friends on Flavor Feed")
                            Text("flavor.feed/anonymous")
                        }
                        Image(systemName: "square.and.arrow.up")
                    }
                })
                UserListView()
                NavigationView{
                    VStack{
                        //Text("\(selectedOption)")
                        Picker("Tabs", selection: $selectedOption) {
                            Text(options[0]).tag(options[0])
                            Text(options[1]).tag(options[1])
                            Text(options[2]).tag(options[2])
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .menuStyle(.borderlessButton)
                    }
                    .background(Color.ffTertiary)
                }
            }
            .background(Color.ffTertiary)
        }
    }
    
}

#Preview {
    AddFriendsView()
}
