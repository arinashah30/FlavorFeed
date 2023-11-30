//
//  Friend.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/1/23.
//

import Foundation

struct Friend: Identifiable, Hashable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return (lhs.id == rhs.id)
    }

    // REQUIRED PROPERTIES
    var id: String // username
    var name: String //displayName
    var profilePicture: String // URL of profile picture
    var bio: String // profile bio
    
    // OPTIONAL PROPERTIES (could be empty arrays)
    var mutualFriends: [String] // array of userIDs of mutual friends (usernames)
    var pins: [String] // array of post IDs
    var todaysPost: String? // friend may not have posted today.
    
}
