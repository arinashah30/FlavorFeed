//
//  AddFriendsView.swift
//  FlavorFeed
//
//  Created by Misry Dhanani on 9/30/23.
//

import SwiftUI

struct Person {
    var name: String
}

struct AddFriendsView: View {
    @State private var selectedOption = "Suggestions"
    var options = ["Suggestions", "Friends", "Requests"]
    @State private var searchText = "hello"
    
    var body: some View {
        VStack{
            NavigationStack {
                Text("Searching for \(searchText)")
                    .navigationTitle("Searchable Example")
            }
            .searchable(text: $searchText)
            NavigationView {
                VStack {
                    Text("\(selectedOption)")
                    Picker("Tabs", selection: $selectedOption) {
                        Text(options[0]).tag(options[0])
                        Text(options[1]).tag(options[1])
                        Text(options[2]).tag(options[2])
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .menuStyle(.borderlessButton)
                }
            }
        }
    }
    
}

#Preview {
    AddFriendsView()
}
