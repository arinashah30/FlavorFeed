//
//  MapView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

// Test Commit
// Test commit 2
struct MapView: View {
    var user: User
    var body: some View {
        VStack {
            HStack {
                Text("My Restaurants")
                    .font(.title2)
                    .padding()
                Spacer()
                Image(systemName: "person.2.fill")
                    .padding()
            }
            
        }
    }
}
