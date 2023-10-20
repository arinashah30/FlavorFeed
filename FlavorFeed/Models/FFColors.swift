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
            Color(red: 255/255, green: 112/255, blue: 112/255)
        } else {
            Color(red: 255/255, green: 112/255, blue: 112/255)
        }
    }
    public static var ffSecondary: Color {
        if darkMode {
            Color(red: 0/255, green: 82/255, blue: 79/255)
        } else {
            Color(red: 0/255, green: 82/255, blue: 79/255)
        }
    }
    public static var ffTertiary: Color {
        if darkMode {
            Color(red: 255/255, green: 215/255, blue: 135/255)
        } else {
            Color(red: 255/255, green: 215/255, blue: 135/255)
        }
    }
    
}
