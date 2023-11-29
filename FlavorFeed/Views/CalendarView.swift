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
    private var dates = [Date]()
    
    init(vm: ViewModel, user: User) {
        self.vm = vm
        self.user = user
        for i in 0..<14 {
            dates.append(Date(timeIntervalSinceNow: TimeInterval(24 * 3600 * i * -1)))
        }
    }
    
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
                            ForEach(dates, id: \.self) { date in
                                    CalendarCollectionViewCell(date: date, vm: vm)
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
    let date: Date
    @ObservedObject var vm: ViewModel
    @State var url = "https://imageio.forbes.com/specials-images/imageserve/5ed6636cdd5d320006caf841/0x0.jpg?format=jpg&height=900&width=1600&fit=bounds"
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 55)
                    .clipped()
                    .cornerRadius(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.ffTertiary, lineWidth: 1)
                            .frame(width: 45, height: 55)
                    )
            } placeholder: {
                ProgressView()
            }

            Text("\(getDay(date: date))")
                .fontWeight(.heavy)
                .foregroundStyle(.white)

        }.onAppear() {
            DispatchQueue.main.async {
                let dayFormatted = getDayformatted(date: date)
                vm.get_post_from_day(day: dayFormatted) { postID in
                    if postID.count > 0 {
                        print(dayFormatted)
                        vm.firebase_get_post(postID: postID) { post in
                            self.url = post.images[0][0]
                            print("Showing image for \(dayFormatted): \(post.images[0][0])")
                        }
                    }
                }
            }
        }
    }
    func getDayformatted(date: Date) -> String {
        return vm.dayFormatter.string(from: date)
    }
    
    func getDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    CalendarView(vm: ViewModel(), user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], requests: [], pins: [], myPosts: []))
}
