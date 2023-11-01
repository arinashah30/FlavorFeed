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
    
    var id: UUID
    var username: String
    var profilePicture: String
    var text: String
    var date: String
    var likes: [User]
    var replies: [Comment]

}
