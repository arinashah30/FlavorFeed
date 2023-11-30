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
    @EnvironmentObject var index: MyPostTodayPreviewVariables
    
    init(post: Post, vm: ViewModel) {
        
        self.post = post
        self.vm = vm
        print("NUMBER OF POST ENTRIES FOUND: \(post.images.count)")
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                
                HStack {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.size.width * 0.37)
                    
                    ForEach(0..<post.images.count, id: \.self) { i in
                        Button {
                            index.myPostIndex = i
                        } label: {
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
                                if (post.comments.count > 0 && i == index.myPostIndex) {
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
                        }
                            .padding(5)
                            .id(i)
                        
                    }
                    Spacer()
                        .frame(width: UIScreen.main.bounds.size.width * 0.37)
                }.scrollTargetLayout()
                .onChange(of: index.myPostIndex) { _ in
                                    if index.myPostIndex >= 0 {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                                value.scrollTo(index.myPostIndex, anchor: .top)
                                            }
                                        }
                                    }
                
            }
        }.scrollDisabled(true)
        .scrollTargetBehavior(.paging)
        
    }
}

#Preview {
    MyPostTodayPreviewView(post: Post(id: UUID().uuidString, userID: "nac5504", images: ["https://firebasestorage.googleapis.com:443/v0/b/flavorfeed-ec138.appspot.com/o/images%2F9CCC81DF-04D0-49E0-931F-12A2411B7413.jpg?alt=media&token=833f3cad-7010-4b5a-88ec-7f09786064bd https://firebasestorage.googleapis.com:443/v0/b/flavorfeed-ec138.appspot.com/o/images%2F9CCC81DF-04D0-49E0-931F-12A2411B7413.jpg?alt=media&token=833f3cad-7010-4b5a-88ec-7f09786064bd"], date: ["11-19-2023 05:33:38 pm"], day: "11-19-2023", comments: [Comment(id: UUID().uuidString, userID: "nac5504", text: "Hello there", date: Date(), profilePicture: "https://firebasestorage.googleapis.com:443/v0/b/flavorfeed-ec138.appspot.com/o/images%2F9CCC81DF-04D0-49E0-931F-12A2411B7413.jpg?alt=media&token=833f3cad-7010-4b5a-88ec-7f09786064bd")], caption: ["WOOHOO"], likes: [], locations: ["Atlanta, GA"], recipes: [], friend: nil), vm: ViewModel())
}
