//
//  User.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import Foundation

struct User: Hashable {
    var id: String
    var name: String
    var username: String
    // var password: String // not secure to store within app. let firebase handle it
    var profilePicture: String
    var email: String
    var favorites: [Post]
    var friends: [User]
    var savedPosts: [Post]
    var bio: String
    var myPosts: [Post]
    var phoneNumber: Int
    var location: String
    var myRecipes: [String] //[Recipe]
    var streak: Int {
        return myPosts.count
    }
}
