//
//  CalendarView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI
import Foundation

struct CalendarView: View {
    @ObservedObject var vm: ViewModel
    var user : User
    @State var posts: [Post] = []
    
    var body: some View {
            VStack {
                HStack {
                    Text("Your Memories")
                        .font(.title2)
                    Spacer()
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                    Text("Only visible to you")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
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
            }
            .padding([.leading, .trailing, .top], 20)
            .onAppear {
                vm.fetchPosts(postIDs: user.myPosts) { posts in
                    self.posts = posts
                }
            }
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
                    .foregroundColor(.white)
                    .padding(2)
            } else {
                Text(formatDate(date: post.date))
                    .font(.system(size: 16)).bold()
                    .foregroundColor(.ffPrimary)
                    .padding(2)
                    .frame(width: 45, height: 55)
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
            .frame(width: 45, height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.ffTertiary, lineWidth: 1)
                    .frame(width: 42, height: 55)
            )
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
    maybePosts.reverse()
    return maybePosts
}

func postForDate(posts: [Post], dateToCheck: Date) -> Post? {
    for post in posts {
        let calendar = Calendar.current
        if (calendar.isDate(findDateFromPost(post: post), inSameDayAs: dateToCheck)) {
            return post
        }
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
    CalendarView(vm: ViewModel(), user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], requests: [], pins: [], myPosts: []))
}
