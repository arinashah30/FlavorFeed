//
//  Post.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import Foundation

struct Post: Identifiable {
    var id: UUID
    var images: [String:String]
    var caption: String
    var recipe: String? //Recipe
    var date: String
    var likes: [User]
    //var comments: [User : String]
    var location: String?
    
}
