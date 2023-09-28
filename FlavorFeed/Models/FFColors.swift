//
//  FFColors.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 9/27/23.
//

import Foundation
import SwiftUI

extension Color {
    static let darkMode = false
    
    public static var ffPrimary: Color {
        if darkMode {
            Color(red: 0.5, green: 0.5, blue: 0.3)
        } else {
            Color(red: 0.1, green: 0.4, blue: 0.3)
        }
    }
    public static var ffSecondary: Color {
        if darkMode {
            Color(red: 0.5, green: 0.5, blue: 0.3)
        } else {
            Color(red: 0.1, green: 0.4, blue: 0.3)
        }
    }
    public static var ffTertiary: Color {
        if darkMode {
            Color(red: 0.5, green: 0.5, blue: 0.3)
        } else {
            Color(red: 0.1, green: 0.4, blue: 0.3)
        }
    }
    
}
