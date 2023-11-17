//
//  FlavorFeedApp.swift
//  FlavorFeed
//
//  Created by Arina Shah on 9/28/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FlavorFeedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            CalendarView(user: User(id: "AustinUserName", name: "Austin", profilePicture: "drake_pfp", email: "austin@gmail.com", bio: "", phoneNumber: "123456789", friends: [], pins: [], myPosts: []))
        }
    }
}
