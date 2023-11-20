//
//  MyPostTodayPreviewView.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/19/23.
//

import SwiftUI

struct MyPostTodayPreviewView: View {
    var post: Post
    
    @ObservedObject var vm: ViewModel
    
    
    init(post: Post, vm: ViewModel) {
        self.post = post
        self.vm = vm
    }
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                VStack {
                    AsyncImage(url: URL(string: post.images[0][0])) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 112, height: 149)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                        
                            .frame(width: 112, height: 149)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if (post.comments.count > 0) {
                        Spacer()
                    }
                }
                
                HStack {
                    VStack {
                        AsyncImage(url: URL(string: post.images[0][1])) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 37, height: 50)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.ffPrimary, lineWidth: 1)
                                )
                                .padding(7)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 37, height: 50)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.ffPrimary, lineWidth: 1)
                                )
                                .padding(7)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                if (post.comments.count > 0) {
                    VStack {
                        Spacer()
                        ZStack(alignment: .center) {
                            Image(systemName: "bubble.right.fill")
                                .foregroundColor(.ffSecondary)
                            Text("\(post.comments.count)")
                                .font(.system(size: 11, weight: .none))
                                .foregroundStyle(.white)
                                .padding(.bottom, 3)
                        }.frame(width: 24, height: 24)
                    }
                }
                
            }.frame(width: 112, height: 160)
                .padding(5)
            
            Text(post.caption[0])
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.ffSecondary)
            Text(post.locations[0])
                .font(.system(size: 12, weight: .none))
            
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    MyPostTodayPreviewView(post: Post(id: UUID().uuidString, userID: "nac5504", images: ["https://firebasestorage.googleapis.com:443/v0/b/flavorfeed-ec138.appspot.com/o/images%2F9CCC81DF-04D0-49E0-931F-12A2411B7413.jpg?alt=media&token=833f3cad-7010-4b5a-88ec-7f09786064bd https://firebasestorage.googleapis.com:443/v0/b/flavorfeed-ec138.appspot.com/o/images%2F9CCC81DF-04D0-49E0-931F-12A2411B7413.jpg?alt=media&token=833f3cad-7010-4b5a-88ec-7f09786064bd"], date: ["11-19-2023 05:33:38 pm"], day: "11-19-2023", comments: [Comment(id: UUID().uuidString, userID: "nac5504", text: "Hello there", date: "11-19-2023 05:24:36")], caption: ["WOOHOO"], likes: [], locations: ["Atlanta, GA"], recipes: [], friend: nil), vm: ViewModel())
}
