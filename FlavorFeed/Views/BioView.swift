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
            Image(user.profilePicture)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 80)
                .clipShape(.circle)
                
            Text(user.name)
                .font(.title)
            Text(user.id)
                .font(.title2)
        }
    }
}
