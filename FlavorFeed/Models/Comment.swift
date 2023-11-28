//
//  Comment.swift
//  FlavorFeed
//

//  Created by Datta Kansal on 10/19/23.
//

import Foundation

struct Comment: Identifiable, Hashable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    // REQUIRED PROPERTIES
    var id: String // comment document ID
    var userID: String // id of user who commented
    var text: String // comment description (the comment itself)
    var date: Date // timestamp of comment
    var profilePicture: String // url of profile image
    
    // OPTIONAL PROPERTIES
    var replies: [Comment]? // replies to comment

}
