//
//  Post.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import Foundation

struct Post: Identifiable, Hashable {
    
    // REQUIRED PROPERTIES
    var id: String // post id
    var userID: String //username
    var images: [[String]] //2d array [[post_1.1, post_1.2], [post_2.1, post_2.2], [post_3.1, post_3.2]]
    var caption: [String] // [caption_1, caption_2, caption_3]
    var date: String // timestamp of post
    var likes: [String] //list of userIDs of users who liked
    var comments: [Comment] //list of comments
    
    // OPTIONAL PROPERTIES
    var location: String? //location of post, if applicable
    var recipe: String? //Recipe, if applicable

}
