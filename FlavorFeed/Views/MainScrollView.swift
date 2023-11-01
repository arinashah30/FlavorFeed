//
//  MainScrollView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/15/23.
//

import SwiftUI

struct MainScrollView: View {
    @ObservedObject var vm: ViewModel
    @Binding var tabSelection: Tabs
    var posts : [Post] = addPosts() //replace with vm.posts later
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TopBar(tabSelection: $tabSelection)
                    //                ScrollView {
                    //                    VStack {
                    //                        ForEach(posts) {post in
                    //                            PostView(post: post).frame(maxHeight: .infinity)
                    //                        }
                    //                    }
                    //                }.frame(maxHeight: .infinity)
                    List(posts, id: \.id) { post in
                        PostView(post: post).frame(width: geometry.size.width, height: 700)
                    }.listStyle(.plain).listRowSeparatorTint(Color.clear)
                }.edgesIgnoringSafeArea(.bottom)
                VStack {
                    Spacer()
                    BottomBar(messagesRemaing: Binding.constant(2)).frame(height: 100).edgesIgnoringSafeArea(.bottom)
                }.edgesIgnoringSafeArea(.bottom).frame(maxHeight: .infinity)
                
            }
        }
    }
}

//can remove this function when we get posts from firebase
func addPosts() -> [Post] {
    var posts: [Post] = []
    
    for i in 1...30 {
        
        posts.append(Post(id: UUID(), userID: UUID(), images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], caption: ["That was yummy in my tummy", "", "Let's dig in"], date: "October 24, 2022", likes: [], comments: [Comment(id: UUID(), username: "Adonis", profilePicture: "adonis_pfp", text: "Looking fresh Drake!", date: "October 24, 2022", likes: [], replies: []), Comment(id: UUID(), username: "Travis Scott", profilePicture: "travis_scott_pfp", text: "She said do you love me I told her only partly.", date: "October 24, 2022", likes: [], replies: [])]))
        
        
    }
    return posts
}

#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView))
}

