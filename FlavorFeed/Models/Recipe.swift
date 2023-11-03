//
//  Recipe.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 11/1/23.
//

import Foundation

struct Recipe: Identifiable, Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id: String

}
