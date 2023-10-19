//
//  ViewModel.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/4/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewModel: ObservableObject {
    @Published private var current_user: User? = nil
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    func firebase_sign_out() {
        do {
            try auth.signOut()
            UserDefaults.standard.set(false, forKey: "log_Status")
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func firebase_email_password_sign_up(email: String, password: String, username: String, displayName: String, phoneNumber: String) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let user = authResult?.user {
                
                let id = user.uid
                self.db.collection("USERS").document(id).setData(
                    ["name" : displayName,
                     "username" : username,
                     "profilePicture" : "",
                     "email" : email,
                     "favorites" : [],
                     "friends" : [],
                     "savedPosts" : [],
                     "bio" : "",
                     "myPosts" : [],
                     "phone_number" : phoneNumber,
                     "location" : "",
                     "myRecipes" : ""
                    ] as [String : Any]
                ) { err in
                    if let err = err {
                        print("Error: \(err.localizedDescription)")
                    } else {
                        
                        self.current_user = User(
                            id: id,
                            name: displayName,
                            username: username,
                            profilePicture: "",
                            email: email,
                            favorites: [],
                            friends: [],
                            savedPosts: [],
                            bio: "",
                            myPosts: [],
                            phoneNumber: Int(phoneNumber)!,
                            location: "",
                            myRecipes: [])
                        
                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                        
                    }
                }
                
            }
            
        }
    }
    
    func firebase_delete_comment(post: Post, comment: Comment) {
        self.db.collection("POSTS").document(post.id.uuidString).collection("comments").document(comment.id.uuidString).delete { err in
            if let err = err {
                print("Error: \(err.localizedDescription)")
            } else {
                // Remove comment on screen
                
            }
        }
    }
}
