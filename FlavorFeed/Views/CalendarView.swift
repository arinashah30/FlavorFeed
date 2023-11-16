//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI
import Foundation

struct CalendarView: View {
    var user : User
    let posts: [Post] = [Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-24-2023 09:14:35", "10-24-2022 12:49:22", "10-24-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2023", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-25-2022 09:14:35", "10-25-2023 12:49:22", "10-25-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 25, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 25, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-26-2023 09:14:35", "10-26-2022 12:49:22", "10-26-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 25, 2023", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 26, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-27-2023 09:14:35", "10-27-2022 12:49:22", "10-27-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 27, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-28-2023 09:14:35", "10-28-2022 12:49:22", "10-28-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 28, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-29-2023 09:14:35", "10-29-2022 12:49:22", "10-29-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 29, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-30-2023 09:14:35", "10-30-2022 12:49:22", "10-30-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 30, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["10-31-2023 09:14:35", "10-31-2022 12:49:22", "10-31-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 31, 2023", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-01-2023 09:14:35", "11-01-2022 12:49:22", "11-01-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 1, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-02-2023 09:14:35", "11-02-2022 12:49:22", "11-02-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 2, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-03-2023 09:14:35", "11-03-2022 12:49:22", "11-03-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 3, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-04-2023 09:14:35", "11-04-2022 12:49:22", "11-04-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 4, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-05-2023 09:14:35", "11-05-2022 12:49:22", "11-05-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 5, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-06-2023 09:14:35", "11-06-2022 12:49:22", "11-06-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 6, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-17-2023 09:14:35", "11-06-2022 12:49:22", "11-06-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 6, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []),
                         Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["11-22-2023 09:14:35", "11-06-2022 12:49:22", "11-06-2022 19:40:12"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "November 6, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: [])] //this is going to be replaced with calls to firebase to fetch posts
    
    var body: some View {
        VStack {
            HStack {
                Text("Your Memories")
                    .font(.title2)
                Spacer()
                Image(systemName: "person.2.fill")
            }
            HStack (alignment: .top) {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 7)){
                        ForEach(getLast14DaysViews(posts: posts), id: \.self) { post in
                            HStack {
                                    CalendarCollectionViewCell(post:post)
                            }
                        }
                    }
                }
            }
            
            //NavigationLink(destination: AllMemoriesView()) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 200, height: 35)
                    .padding()
                Text("View All My Memories")
            }
        }
        .padding()
    }
}

struct CalendarCollectionViewCell: View {
    let post: MaybePost
    var body: some View {
        ZStack {
            if post.image != nil {
                CalendarImage(post: post)
                Text(formatDate(date: post.date))
                    .font(.system(size: 16)).bold()
                    .padding(2)
            } else {
                Text(formatDate(date: post.date))
                    .font(.system(size: 16)).bold()
                    .padding(2)
            }
        }
    }
}

struct CalendarImage: View {
    let post: MaybePost
    var body: some View {
        Image(self.post.image!)
            .resizable()
            .scaledToFit()
            .frame(width: 45, height: 55).opacity(0.6)
            .cornerRadius(9)
    }
}



struct MaybePost: Hashable {
    var date: Date
    var image: String?
}

func getLast14DaysViews(posts: [Post]) -> [MaybePost] {
    var maybePosts: [MaybePost] = []
    let today = Date()
    let lastTwoWeekDates = getLast14Days(from: today)
    for date in lastTwoWeekDates {
        if let post = postForDate(posts: posts, dateToCheck: date) {
            maybePosts.append(contentsOf: [MaybePost(date: date, image: post.images[0][1])])
        } else {
            maybePosts.append(contentsOf: [MaybePost(date: date, image: nil)])
        }
    }
    return maybePosts
}

func postForDate(posts: [Post], dateToCheck: Date) -> Post? {
//    print(posts)
    for post in posts {
        print("post date: \(findDateFromPost(post: post))")
        print("date to check: \(dateToCheck)")
        
        let calendar = Calendar.current
        print(calendar.isDate(findDateFromPost(post: post), inSameDayAs: dateToCheck))
        
        if (calendar.isDate(findDateFromPost(post: post), inSameDayAs: dateToCheck)) {
            return post
        }
        //    let postForDate = posts.first { post in
        //        let calendar = Calendar.current
        //        ifcalendar.isDate(findDateFromPost(post: post), inSameDayAs: dateToCheck)
        //    }
        //    print(postForDate)
        //    return postForDate
    }
    return nil
}

func hasPostForDate(posts: [Post], dateToCheck: Date) -> Bool {
    let hasPostForDate = posts.contains { post in
        let calendar = Calendar.current
        return calendar.isDate(findDateFromPost(post: post), inSameDayAs: dateToCheck)
    }
    
    return hasPostForDate
}


func getLast14Days(from startDate: Date) -> [Date] {
    var dates: [Date] = []
            let calendar = Calendar.current
            for i in 0..<14 {
                if let date = calendar.date(byAdding: .day, value: -i, to: startDate) {
                    dates.append(date)
                }
            }
            return dates
}

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"
    return dateFormatter.string(from: date)
}

func findDateFromPost(post: Post) -> Date! {
    let dateString = post.date[0].prefix(10)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let date = dateFormatter.date(from: String(dateString))
    return date
}

#Preview {
    CalendarView(user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: []))
}
