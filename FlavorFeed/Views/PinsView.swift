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
    var posts: [Post] = [Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["01-24-2023 09:14:35", "10-24-2022 12:49:22", "10-24-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2023", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "waffles"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-13-2023 09:14:35", "10-25-2023 12:49:22", "10-25-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 25, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 25, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_2"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["8-12-2023 09:14:35", "10-26-2022 12:49:22", "10-26-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 25, 2023", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 26, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_3"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-30-2023 09:14:35", "10-27-2022 12:49:22", "10-27-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 27, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [])] //this is going to be replaced with calls to firebase to fetch user's pins
    
    var body: some View {
        VStack {
            HStack {
                Text("Pins")
                    .font(.title2)
                Spacer()
                Image(systemName: "eye.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                Text("Visible to friends")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
            }
            .padding([.leading,.trailing,.top], 20)
            ScrollView(.horizontal) {
                HStack {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: .init(dash: [5]))
                            .stroke(Color.ffTertiary, lineWidth: 2)
                            .frame(width: 110, height: 136)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.ffPrimary)
                    }
                    .padding(.leading)
                    .padding(.bottom, 30)
                    
                    ForEach(posts) { post in
                        VStack {
                            Image(post.images[0][1])
                                .resizable()
                                .frame(width: 110, height: 136)
                                .clipped()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.ffTertiary, lineWidth: 5)
                                )
                                .cornerRadius(10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 12.5)
                                    .frame(width: 100, height: 25)
                                    .foregroundColor(.ffTertiary)
                                Text(postDate(post: post))
                                    .font(.system(size: 13))
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .padding(.top,1)
            }
        }
    }
}


func postDate(post: Post) -> String {
    let dateString = post.date[0].prefix(10)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    if let date = dateFormatter.date(from: String(dateString)) {
        dateFormatter.dateFormat = "MMM d, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    } else {
        return "Invalid date"
    }
}

#Preview {
    PinsView(user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: []))
}
