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
    @Binding var showCamera: Bool
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
                    BottomBar(showCamera: $showCamera, messagesRemaining: Binding.constant(2))
                        .frame(height: 120)
                        .cornerRadius(10)
                }.edgesIgnoringSafeArea(.bottom).frame(maxHeight: .infinity)
                
            }
            .zIndex(0)
        }
    }
}

//can remove this function when we get posts from firebase
func addPosts() -> [Post] {
    var posts: [Post] = []
    
    for i in 1...30 {
        
        posts.append(Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []))
        
        
    }
    return posts
}

#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView), showCamera: Binding.constant(false))
}

