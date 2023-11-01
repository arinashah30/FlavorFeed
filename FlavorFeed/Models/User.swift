//
//  User.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import Foundation


struct User: Identifiable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.id == rhs.id)
    }

    // REQUIRED PROPERTIES
    var id: String // username
    var name: String // display name
    var profilePicture: String // url of profile picture
    var email: String // email address
    var bio: String // profile bio
    var phoneNumber: String // String of phone number
    
    var pins: [String] // array of post IDs
    var friends: [String] // array of userIDs (usernames)
    
    // OPTIONAL PROPERTIES
    var myPosts: [String]? // array of all user posts (may not always need all of your posts)
}
