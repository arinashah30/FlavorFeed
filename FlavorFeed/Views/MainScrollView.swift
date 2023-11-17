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
                        PostView(post: post, recipe: Recipe(id: "id", title: "Fruit Salad", link: nil, ingredients: ["apple", "banana", "orange", "strawberry"], directions: "Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.Step 1: For the sauce: Bring orange juice, lemon juice, brown sugar, orange zest, and lemon zest to a boil in a saucepan over medium-high heat. Reduce heat to medium-low and simmer until slightly thickened, about 5 minutes. Remove from heat and stir in vanilla extract. Set aside to cool. For the salad: Layer fruit in a large, clear glass bowl in this order: pineapple, strawberries, kiwi fruit, bananas, oranges, grapes, and blueberries. Pour cooled sauce over fruit; cover and refrigerate for 3 to 4 hours before serving.")).frame(width: geometry.size.width, height: 700)

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
//
////can remove this function when we get posts from firebase
//func addPosts() -> [Post] {
//    var posts: [Post] = []
//    
//    for i in 1...30 {
//        
//        posts.append(Post(id: UUID().uuidString, userID: "champagnepapi", images: [["drake_selfie", "food_pic_1"], ["drake_selfie2", "food_pic_2"], ["drake_selfie3", "food_pic_3"]], date: ["October 24, 2022", "October 24, 2022", "October 24, 2022"], day: "String", comments: [Comment(id: UUID().uuidString, userID: "adonis", text: "Looking fresh Drake!", date: "October 24, 2022", replies: []), Comment(id: UUID().uuidString, userID: "travisscott", text: "She said do you love me I told her only partly.", date: "October 24, 2022", replies: [])], caption: ["That was yummy in my tummy", "", "Let's dig in"], likes: [], locations: [], recipes: []))
//        
//        
//    }
//    return posts
//}

#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView))
}

