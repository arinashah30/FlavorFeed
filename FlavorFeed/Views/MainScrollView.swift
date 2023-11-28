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
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TopBar(tabSelection: $tabSelection)
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
                        }
                        
                        ForEach(vm.todays_posts, id: \.self) { post in
                            PostView(vm: vm, post: post)
                                .frame(idealWidth: geometry.size.width, minHeight: 700, idealHeight: 750, maxHeight: .infinity)
                        }
                        Spacer()
                            .frame(height: geometry.size.height * 0.5)
                    }
                    .refreshable {
                        DispatchQueue.main.async {
                            vm.refreshFeed {
                                // do nothing
                            }
                        }
                    }
                }
                VStack {
                    Spacer()
                    BottomBar(messagesRemaing: (3 - (vm.my_post_today?.images.count ?? 0)), vm: vm).frame(height: 100).edgesIgnoringSafeArea(.bottom)
                }.edgesIgnoringSafeArea(.bottom).frame(maxHeight: .infinity)
                
            }
        }.environmentObject(myPostVars)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
#Preview {
    MainScrollView(vm: ViewModel(), tabSelection: Binding.constant(Tabs.mainScrollView))
}

// Our observable object class
class MyPostTodayPreviewVariables: ObservableObject {
    @Published var myPostIndex = 0
}

