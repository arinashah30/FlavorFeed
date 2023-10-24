//
//  FriendsBioView.swift
//  FlavorFeed
//
//  Created by Michelle Lee on 10/24/23.
//

import Foundation
import SwiftUI

struct FriendsBioView: View {
    var user: User
    var body: some View {
        VStack {
            Image("profile picture")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 80)
                .cornerRadius(40)
            Text(user.name)
                .font(.title)
            Text(user.username)
                .font(.title2)
        }
    }
}
