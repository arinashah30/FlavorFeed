//
//  PinsView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct PinsView: View {
    var user: User
    var body: some View {
        VStack {
            HStack {
                Text("Favorite Places")
                    .font(.title2)
                    .padding()
                Spacer()
                Image(systemName: "person.2.fill")
                    .padding()
            }
            ScrollView(.horizontal) {
                ZStack {
                    Rectangle()
                        .stroke(style: .init(dash: [5]))
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 200)
                        .padding()
                    Image(systemName: "plus")
                }
            }
        }
    }
}
