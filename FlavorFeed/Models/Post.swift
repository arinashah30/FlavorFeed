//
//  Post.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import Foundation

struct Post: Identifiable {
//    static func == (lhs: Post, rhs: Post) -> Bool {
//        <#code#>
//    }
    
    var id: UUID
    var userID: UUID
    var images: [[String]]
    var caption: String
    var recipe: String? //Recipe
    var date: String
    var likes: [User]?
    var comments: [Comment]?
    var location: String?
    
}
