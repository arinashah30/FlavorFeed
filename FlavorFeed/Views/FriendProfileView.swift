//
//  FriendProfileView.swift
//  FlavorFeed
//
//  Created by Tanishqa Kuchi on 11/16/23.
//

import SwiftUI
import MapKit
import Foundation

struct FriendProfileView: View {
    @ObservedObject var vm: ViewModel
    @Binding var friend: Friend?
    @Binding var showFriendProfile: Bool
    @State var mutualFriendProfilePics: [URL] = []
    @State var showFullMap = false
    @State var posts : [Post]? = nil
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            HStack {
                Button {
                    showFriendProfile = false
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                }.padding()
                Spacer()
            }
            
            ScrollView{
                BioView(vm: vm, profilePicture: friend?.profilePicture ?? "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png", name: friend?.name ?? "", id: friend?.id ?? "", bio: friend?.bio ?? "No bio")
                VStack {
                    HStack{
                        ZStack {
                            ForEach(mutualFriendProfilePics.indices, id: \.self) { index in
                                vm.imageLoader.img(url: mutualFriendProfilePics[index]) { image in
                                    image.resizable()
                                }.clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .offset(x: CGFloat(20 * index), y: 0)
                            }
                        }.padding(.trailing, 40)
                        
                        Text("Friends with \(friend?.mutualFriends[0] ?? ""), \(friend?.mutualFriends[1] ?? "") and \((friend?.mutualFriends.count ?? 0) - 2) more")
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .foregroundColor(.gray)
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    VStack {
                        Text("Today's Post").font(.title2).foregroundColor(Color.ffPrimary)
                        if let postID = friend?.todaysPost, let post = vm.todays_posts.first(where: { $0.id == postID }) {
                            FriendPostToday(post: post, vm: vm)
                        } else {
                            Text("\(friend?.name ?? "") hasn't posted today 😢").foregroundColor(Color.ffPrimary)
                        }
                    }.frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25.0).fill(Color(.systemGray6)).frame(maxWidth: .infinity))
                }.padding()

                PinsView(vm: vm, id: (friend?.id ?? ""), friend: friend)
                Button(action: {
                    if (posts != nil) {
                        showFullMap.toggle()
                    }
                }, label: {
                    MapView(vm: vm, showFullMap: $showFullMap, friendPosts: $posts)
                        .frame(height: 400)
                })
                .fullScreenCover(isPresented: $showFullMap, content: {
                    MapView(vm: vm, showFullMap: $showFullMap, friendPosts: $posts)
                })
            }
        }
        .ignoresSafeArea()
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                var dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                vm.getUserPosts(userID: friend?.id ?? "") { posts in
                    self.posts = posts
                    dispatchGroup.leave()
                }
                dispatchGroup.enter()
                vm.getUserProfilePic(userIDs: Array(friend?.mutualFriends.prefix(3) ?? [])) { urls in
                    self.mutualFriendProfilePics = urls
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) {
                        // Code here will run when both getUserPosts and getUserProfilePic are finished
                        print("Both tasks are complete in FriendProfileView")
                    }
            }
        
        
        
    }
    
}



//#Preview {
//    FriendProfileView(vm: ViewModel(), friend: Friend(id: "champagnepapi", name: "Drake", profilePicture: "https://images-prod.dazeddigital.com/463/azure/dazed-prod/1300/0/1300889.jpeg", bio: "I am Drake", mutualFriends: [], pins: [], todaysPosts: []), showFriendProfile: Binding.constant(true))
//}
