//
//  Post.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import Foundation

struct Post: Identifiable, Hashable {
        
    init(id: String, userID: String, images: [String], date: [String], day: String, comments: [Comment], caption: [String], likes: [String], locations: [String], recipes: [Recipe]) {
        self.id = id
        self.userID = userID
        
        self.images = [[String]]()
        
        for i in 0..<images.count {
            self.images.append(images[i].components(separatedBy: " "))
        }
        self.date = date
        self.day = day
        self.comments = comments
        self.caption = caption
        self.likes = likes
        self.locations = locations
        self.recipes = recipes
    }
    
    // REQUIRED PROPERTIES
    var id: String // post id
    var userID: String //username
    var images: [[String]] //2d array [[post_1.1, post_1.2], [post_2.1, post_2.2], [post_3.1, post_3.2]]
    var date: [String] // [timestamp_1, timestamp_2, timestamp_3]
    var day: String
    
    // OPTIONAL PROPERTIES (could be empty arrays)
    var comments: [Comment] //list of comments
    var caption: [String] // [caption_1, caption_2, caption_3]
    var likes: [String] //list of userIDs of users who liked
    var locations: [String] //location of post, if applicable [location_1, location_2, location_3]
    var recipes: [Recipe] //Recipe, if applicable [recipe_1, recipe_2, recipe_3]

}
