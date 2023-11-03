//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct CalendarView: View {
    var user : User
    var posts: [Post] = [Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [])] //this is going to be replaced with calls to firebase to fetch posts
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                ForEach(0..<7) { daysPast in
                    
                    ZStack {
                        
                        Image(posts[0].images[0][1]).resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45).opacity(0.6)
                        Text(formatDate(date:(Date(timeIntervalSinceNow: TimeInterval(60 * -60 * 24 * daysPast)))))
                            .font(.system(size: 14)).bold()
                            .padding()
                        
                    }
                    
                }
                
            }
            HStack {
                ForEach(7..<14) { daysPast in
                    
                    ZStack {
                        Image(posts[0].images[0][1]).resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45).opacity(0.6)
                        Text(formatDate(date:(Date(timeIntervalSinceNow: TimeInterval(60 * -60 * 24 * daysPast)))))
                            .font(.system(size: 14)).bold()
                            .padding()
                    }
                }
            }
        }
    }
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    CalendarView(user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: []))
}
