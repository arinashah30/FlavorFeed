//
//  CreatePostView.swift
//  FlavorFeed
//
//  Created by Rik Roy on 10/17/23.
//

import SwiftUI

struct CreatePostView: View {
    @ObservedObject var vm: ViewModel
    @State var image: String = ""
    @State var caption: String = ""
    @State var recipe: String = ""
    @State var date: String = ""
    @State var likes: String = ""
    @State var comments: String = ""
    var body: some View {
        VStack {
            TextField("images", text: $image);
            TextField("caption", text: $caption);
            TextField("recipe", text: $recipe);
            TextField("date", text: $date);
            TextField("likes", text: $likes);
            TextField("comments", text: $comments);
            
            Button {
                vm.firebase_create_post(
                    images: self.image,
                    caption: self.caption,
                    recipe: self.recipe,
                    location: "Somewhere")
            } label: {
                Text("Create")
            }
        }
    }
}

#Preview {
    CreatePostView(vm: ViewModel())
}
