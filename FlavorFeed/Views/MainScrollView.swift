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
    
    @StateObject var myPostVars = MyPostTodayPreviewVariables()
    
    
    var body: some View {
        NavigationStack {
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
                        ScrollView {
                            if let myPost = vm.my_post_today {
                                Text("Your Post Today!")
                                    .font(.title)
                                    .foregroundStyle(Color.ffSecondary)
                                    .underline()
                                MyPostTodayPreviewView(post: myPost, vm: vm)
                                Text(myPost.caption[myPostVars.myPostIndex])
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.ffSecondary)
                                Text(myPost.locations[myPostVars.myPostIndex])
                                    .font(.system(size: 12, weight: .none))
                                    .foregroundStyle(Color.gray)
                            } else {
                                Text("You have not posted yet today.")
                                    .bold()
                            }
                            
                            ForEach(vm.todays_posts, id: \.self) { post in
                                PostView(vm: vm, post: post)
                                    .frame(width: geometry.size.width, height: 700)
                            }
                            Spacer()
                        }
                            .refreshable {
                                DispatchQueue.main.async {
                                    vm.refreshFeed {
                                        
                                    }
                                }
                            }
                    }
                    VStack {
                        Spacer()
                        BottomBar(messagesRemaing: Binding.constant(2), vm: vm).frame(height: 100).edgesIgnoringSafeArea(.bottom)
                    }.edgesIgnoringSafeArea(.bottom).frame(maxHeight: .infinity)
                    
                }
            }.environmentObject(myPostVars)
        }
    }
}
#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView))
}

// Our observable object class
class MyPostTodayPreviewVariables: ObservableObject {
    @Published var myPostIndex = 0
}

