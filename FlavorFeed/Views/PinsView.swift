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
    @ObservedObject var vm: ViewModel
    var user: User
    @State var pins: [Post] = []
    
    
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
                    
                    ForEach(pins) { post in
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
        }.onAppear {
            vm.fetchPosts(postIDs: user.pins) { posts in
                self.pins = posts
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
    PinsView(vm: ViewModel(), user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: []), pins: [])
}
