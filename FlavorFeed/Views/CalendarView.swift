//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct CalendarView: View {
    var user : User
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                ForEach(0..<7) { daysPast in
                    
                    ZStack {
                        
                        Image(user.myPosts[0].images[0]).resizable()
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
                        Image(user.myPosts[0].images[0]).resizable()
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
    CalendarView(user: User(id: UUID(), name: "Austin Huguenard", username: "austinhuguenard", password: "doesntmatter", profilePicture: "profile picture", email: "na", favorites: [Post(id: UUID(), images: ["waffles"], caption: "nothing", date: "nothing", likes: [], comments: [:], location: "none"), Post(id: UUID(), images: ["waffles"], caption: "nothing", date: "nothing", likes: [], comments: [:], location: "none"), Post(id: UUID(), images: ["waffles"], caption: "nothing", date: "nothing", likes: [], comments: [:], location: "none")], friends: [], savedPosts: [], bio: "nothing", myPosts: [Post(id: UUID(), images: ["waffles"], caption: "nothing", date: "nothing", likes: [], comments: [:], location: "none")], phoneNumber: 7705958485, location: "Georgia", myRecipes: []))
}
