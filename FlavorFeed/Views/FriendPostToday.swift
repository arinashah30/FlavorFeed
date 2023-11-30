//
//  FriendPostToday.swift
//  FlavorFeed
//
//  Created by Arina Shah on 11/29/23.
//

import SwiftUI

struct FriendPostToday: View {
    var post: Post
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                
                HStack {
                    ForEach(0..<post.images.count, id: \.self) { i in
                        VStack {
                            ZStack {
                                VStack {
                                    vm.imageLoader.img(url: URL(string: post.images[i][0])!) { image in
                                        image.resizable()
                                    }.aspectRatio(contentMode: .fit)
                                        .frame(width: 112, height: 149)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    if (post.comments.count > 0) {
                                        Spacer()
                                    }
                                }
                                
                                HStack {
                                    VStack {
                                        vm.imageLoader.img(url: URL(string: post.images[i][1])!) { image in
                                            image.resizable()
                                        }.aspectRatio(contentMode: .fit)
                                            .frame(width: 37, height: 50)
                                            .cornerRadius(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.ffPrimary, lineWidth: 1)
                                            )
                                            .padding(7)
                                        
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
                            Text(post.caption[i])
                                .frame(width: 112)
                                .foregroundStyle(Color.ffSecondary)
                                .minimumScaleFactor(0.4)
                                .lineLimit(1)
                                .font(.system(size: 12, weight: .semibold))
                                
                            Text(post.locations[i])
                                .font(.system(size: 12, weight: .none))
                                .foregroundStyle(Color.gray)
                        }

                        
                    }
                }.scrollTargetLayout()
                
            }
        }
        .scrollTargetBehavior(.paging)
        
    }
}

//#Preview {
//    FriendPostToday()
//}
