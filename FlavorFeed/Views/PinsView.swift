//
//  PinsView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

//
//  PinsView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct PinsView: View {
    var user: User
    var posts: [Post] = [Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [])] //this is going to be replaced with calls to firebase to fetch user's pins
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
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: .init(dash: [5]))
                            .foregroundColor(.gray)
                            .frame(width: 102, height: 136)
                            .padding(.leading)
                        Image(systemName: "plus")
                            .resizable()
                            //.padding(.leading)
                            .frame(width: 30, height: 30)
                    }
                    ForEach(posts) { post in
                        Image(post.images[0][1])
                            .resizable()
                            //.aspectRatio(contentMode: .fit)
                            .frame(width: 102, height: 136)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
                .frame(maxHeight: 200)
            }
        }
    }
}
