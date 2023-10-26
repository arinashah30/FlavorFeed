//
//  SearchBarTest.swift
//  FlavorFeed
//
//  Created by Rik Roy on 10/24/23.
//

import SwiftUI

struct SearchBarTest: View {
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @ObservedObject var vm = ViewModel()
    @State var username: String = "";
    
    var searchResults: [String] = []
    
    var body: some View {
        NavigationStack {
            TextField("Username", text: $username).autocapitalization(.none)
                
                .onChange(of: username, perform: { value in
//                    DispatchQueue.main.async {
//                        getUsers(username: value)
//                    }
                    getUsers(username: value)
                })
            List {
                ForEach(vm.searchResults, id:\.self) { num in
                    Text(String(num))
                }
            }
        }
        
    }
    func getUsers(username: String) {
        vm.firebase_search_for_username(username: username) { arr in
            vm.searchResults = arr
            print(vm.searchResults)
        }
    }
    
    
}

#Preview {
    SearchBarTest()
}
