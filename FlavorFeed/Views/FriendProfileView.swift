//
//  FriendProfileView.swift
//  FlavorFeed
//
//  Created by Julia Kim on 10/3/23.
//

import SwiftUI

struct FriendProfileView: View {
    //@binding var tabSelection: Tabs
    var body: some View {
        let friendData = User(id: UUID(), name: "Julia Kim", username: "juliakim", password: "12345", profilePicture: "image.png", email: "jk@gmail.com", favorites: [], friends: [], savedPosts: [], bio: "hello", myPosts: [Post(id: UUID(), images: ["dummy.jpeg" : "caption"], caption: "hello", recipe: "recipe", date: "9/1/23", likes: [], comments: [:], location: "atlanta")], phoneNumber: 1234567890, location: "atlanta", myRecipes: ["chicken", "pasta"])
        VStack {
            HStack {
                Image(friendData.myPosts[myPosts.count-1].images[0])
                VStack {
                    Text("Today's BeReal")
                    HStack {
                        Text(String(friendData.myPosts[myPosts.count-1].location))
                        Text(String(friendData.myPosts[myPosts.count-1].date))
                        //SPACE
                        Text(String(format: "View all %d reactions", friendData.myPosts[-1].likes.count))
                    }
                    
                }
            }
            .border(.white)
        }
    }
}

#Preview {
    FriendProfileView()
}
