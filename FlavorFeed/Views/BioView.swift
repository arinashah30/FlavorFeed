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
               Image("profile Pic 2")
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(maxWidth: 100, maxHeight: 200)
                   .clipShape(.ellipse)
               
               
               Text(user.username)
                   .font(.title)
               
               Text("Friend for 2 years")
                   .font(.system(size: 15))
                   .foregroundColor(.gray)
               
           }
       }
   }

