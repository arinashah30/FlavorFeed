//
//  Comment.swift
//  FlavorFeed
//
//  Created by Datta Kansal on 10/19/23.
//

import Foundation
struct Comment: Identifiable {
    
    var id: UUID
    var username: String
    var profilePicture: String
    var caption: String
    
}
