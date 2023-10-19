//
//  BioView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct BioView: View {
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