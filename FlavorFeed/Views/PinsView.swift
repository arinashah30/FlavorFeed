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
                Text("Pins")
                    .font(.title2)
                    .padding()
                Spacer()
                Image(systemName: "person.2.fill")
                    .padding()
            }
            ScrollView(.horizontal) {
                HStack {
                    ZStack {
                        Rectangle()
                            .stroke(style: .init(dash: [5]))
                            .foregroundColor(.gray)
                            .frame(width: 102, height: 136)
                            .padding(.leading)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    ForEach(user.favorites) { post in
                        Image(post.images[0])
                            .resizable()
                            //.aspectRatio(contentMode: .fit)
                            .frame(width: 102, height: 136)
                            .clipped()
                    }
                }
                .frame(maxHeight: 200)
            }
        }
    }
}
