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
    var friend: Friend
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            ScrollView{
                BioView(profilePicture: friend.profilePicture, name: friend.name, id: friend.id, bio: friend.bio)
                VStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .fill(Color(.systemGray6))
                        HStack {
                            ZStack{
                                Image("food_example")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                    .border(Color.yellow)
                                    .cornerRadius(20)
                                Image("person_example")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, alignment: .leading)
                                    .border(Color.red)
                                    .cornerRadius(10)
                                    .offset(x:-30,y:-50)
                            }
                            VStack {
                                Text("Today's Flavor Feed")
                                    .font(.system(size:20)).bold()
                                Text("Washington, Georgetown - 5 hrs late")
                                    .minimumScaleFactor(0.4).lineLimit(1)
                                Spacer()
                                Button(action: {
                                }) {
                                    Text("Add a comment...")
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .font(.system(size:15))
                                        .cornerRadius(20)
                                }
                            }
                        }.padding()
                    }
                }.padding()
                
                HStack{
                    if (friend.mutualFriends.count > 2) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 100, height: 50) // Adjust width and height as needed
                                .offset(x: -150, y: 0) // Offset the first ellipse up by half its height
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 100, height: 50)
                                .offset(x: -120, y: 0)
                            
                            Circle()
                                .fill(Color.red)
                                .frame(width: 100, height: 50)
                                .offset(x: -90, y: 0)
                            
                            
                            Text("Friend with \(friend.mutualFriends[0]), \(friend.mutualFriends[1]) and \(friend.mutualFriends.count - 2) more")
                                .offset(x: 40)
                                .frame(maxWidth: 200)
                                .background(Color.clear)
                                .foregroundColor(.gray)
                        }.offset(x:0)
                    }
                    
                }
                .padding()
                PinsView(vm: vm, id: friend.id)
                MapView(restaurants: [CLLocationCoordinate2D(latitude: 43, longitude: 100), CLLocationCoordinate2D(latitude: -10, longitude: 30), CLLocationCoordinate2D(latitude: 20, longitude: -50), CLLocationCoordinate2D(latitude: 17, longitude: -40)])
                    .frame(height: 400)
            }
        }.ignoresSafeArea()
            .toolbarBackground(.hidden, for: .navigationBar)
        
    }
}

#Preview {
    FriendProfileView(vm: ViewModel(), friend: Friend(id: "champagnepapi", name: "Drake", profilePicture: "https://images-prod.dazeddigital.com/463/azure/dazed-prod/1300/0/1300889.jpeg", bio: "I am Drake", mutualFriends: [], pins: [], todaysPosts: []))
}
