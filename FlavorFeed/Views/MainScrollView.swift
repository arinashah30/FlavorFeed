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
        ZStack {
            VStack {
                TopBar(tabSelection: $tabSelection)
                VStack {
                    PostView(post: posts[0]).frame(maxHeight: .infinity)
                }
//                ScrollView {
//                    ForEach(posts) {post in
//                        PostView(post: post).frame(maxHeight: .infinity)
//                    }
//                }.frame(maxHeight: .infinity)
            }.edgesIgnoringSafeArea(.bottom)
            VStack {
                Spacer()
                BottomBar(messagesRemaing: Binding.constant(2)).frame(height: 100).edgesIgnoringSafeArea(.bottom)
            }.edgesIgnoringSafeArea(.bottom).frame(maxHeight: .infinity)

        }
    }
}

//can remove this function when we get posts from firebase
func addPosts() -> [Post] {
    let posts: [Post] = [Post(id: UUID(), userID: UUID(), images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], caption: ["Let's dig in!", "", "That was yummy in my tummy"], date: "October 24, 2022", likes: [], comments: [Comment(id: UUID(), username: "Adonis", profilePicture: "adonis_pfp", text: "Looking fresh Drake!", date: "October 24, 2022", likes: [], replies: []), Comment(id: UUID(), username: "Travis Scott", profilePicture: "travis_scott_pfp", text: "She said do you love me I told her only partly.", date: "October 24, 2022", likes: [], replies: [])]), Post(id: UUID(), userID: UUID(), images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], caption: ["Let's dig in!", "", "That was yummy in my tummy"], date: "October 24, 2022", likes: [], comments: [Comment(id: UUID(), username: "Adonis", profilePicture: "adonis_pfp", text: "Looking fresh Drake!", date: "October 24, 2022", likes: [], replies: []), Comment(id: UUID(), username: "Travis Scott", profilePicture: "travis_scott_pfp", text: "She said do you love me I told her only partly.", date: "October 24, 2022", likes: [], replies: [])]), Post(id: UUID(), userID: UUID(), images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], caption: ["Let's dig in!", "", "That was yummy in my tummy"], date: "October 24, 2022", likes: [], comments: [Comment(id: UUID(), username: "Adonis", profilePicture: "adonis_pfp", text: "Looking fresh Drake!", date: "October 24, 2022", likes: [], replies: []), Comment(id: UUID(), username: "Travis Scott", profilePicture: "travis_scott_pfp", text: "She said do you love me I told her only partly.", date: "October 24, 2022", likes: [], replies: [])])]
    return posts
}

#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView))
}

