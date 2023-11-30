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
    @StateObject var myPostVars = MyPostTodayPreviewVariables()
    
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
                MapView(restaurants: [CLLocationCoordinate2D(latitude: 43, longitude: 100), CLLocationCoordinate2D(latitude: -10, longitude: 30), CLLocationCoordinate2D(latitude: 20, longitude: -50), CLLocationCoordinate2D(latitude: 17, longitude: -40)])
                    .frame(height: 400)
            }
        }.environmentObject(myPostVars)
        .ignoresSafeArea()
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                vm.getUserProfilePic(userIDs: Array(friend?.mutualFriends.prefix(3) ?? [])) { urls in
                    self.mutualFriendProfilePics = urls
                }
            }
        
    }
}



//#Preview {
//    FriendProfileView(vm: ViewModel(), friend: Friend(id: "champagnepapi", name: "Drake", profilePicture: "https://images-prod.dazeddigital.com/463/azure/dazed-prod/1300/0/1300889.jpeg", bio: "I am Drake", mutualFriends: [], pins: [], todaysPosts: []), showFriendProfile: Binding.constant(true))
//}
