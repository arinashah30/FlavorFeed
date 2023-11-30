//
//  BioView.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/3/23.
//

import SwiftUI

struct BioView: View {
    @ObservedObject var vm: ViewModel
    var profilePicture: String
    var name: String
    var id: String
    var bio: String
    
    var body: some View {
        VStack (alignment: .center) {
            vm.imageLoader.img(url: URL(string: profilePicture) ?? URL(string: "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png")!) { image in
                image
                    .resizable()
            }
                .aspectRatio(contentMode: .fill)
                .frame(width: 80)
                .clipShape(.circle)
                
            Text(name)
                .font(.title)
                .foregroundColor(Color.ffSecondary)
            Text("@" + id)
                .font(.system(size: 15))
                .foregroundColor(.gray)
            
            Text(bio)
                .font(.system(size: 20))
                .foregroundColor(Color.ffSecondary)
        }
    }
}
