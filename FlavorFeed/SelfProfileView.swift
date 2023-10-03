//
//  SelfProfileView.swift
//  Bereal4Food
//
//  Created by Nicholas Candello on 9/12/23.
//

import SwiftUI

struct SelfProfileView: View {
    @Binding var tabSelection: Tabs
    var user = User(id: UUID(), name: "Austin Huguenard", username: "austinhuguenard", password: "doesntmatter", profilePicture: "profile picture", email: "na", favorites: [Post(id: UUID(), images: ["waffles": "value"], caption: "nothing", date: "nothing", likes: [], comments: [:], location: "none")], friends: [], savedPosts: [], bio: "nothing", myPosts: [], phoneNumber: 7705958485, location: "Georgia", myRecipes: [])
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
            BioView(user: user)
            PinsView(user: user)
            CalendarView(user: user)
            MapView(user: user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var tabSelection: Tabs = .selfProfileView
    static var previews: some View {
        SelfProfileView(tabSelection: $tabSelection)
    }
}
