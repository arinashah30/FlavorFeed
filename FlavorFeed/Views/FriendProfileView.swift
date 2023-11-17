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
    @Binding var tabSelection: Tabs
    @ObservedObject var vm: ViewModel
    var user = User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: [])
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.tabSelection = .mainScrollView
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.system(size: 40))
                }
                Spacer()
            }.padding()
            ScrollView{
                BioView(user: user)
                PinsView(user: user)
                CalendarView(user: user)
                MapView(user: user, restaurants: [CLLocationCoordinate2D(latitude: 43, longitude: 100), CLLocationCoordinate2D(latitude: -10, longitude: 30), CLLocationCoordinate2D(latitude: 20, longitude: -50), CLLocationCoordinate2D(latitude: 17, longitude: -40)])
                    .frame(height: 400)
            }
        }
    }
}

#Preview {
    FriendProfileView()
}
