//
//  BioView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct BioView: View {
    var profilePicture: String
    var name: String
    var id: String
    
    var body: some View {
        VStack (alignment: .center) {
            AsyncImage(url: URL(string: profilePicture)) { image in
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
                
            Text(name)
                .font(.title)
            Text("@" + id)
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
    }
}
