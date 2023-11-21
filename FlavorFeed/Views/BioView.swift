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
        VStack (alignment: .center) {
            AsyncImage(url: URL(string: user.profilePicture)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 80)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 80)
                    .clipShape(.circle)
            }
                
            Text(user.name)
                .font(.title)
            Text("@" + user.id)
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
    }
}
