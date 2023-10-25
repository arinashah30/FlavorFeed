//
//  Comment.swift
//  FlavorFeed
//
//  Created by Austin Huguenard on 10/12/23.
//

import Foundation

struct Comment: Identifiable, Hashable {
    var id: UUID
    var user: User
    var text: String
    var date: String
    var likes: [User]
    var replies: [Comment]
}
