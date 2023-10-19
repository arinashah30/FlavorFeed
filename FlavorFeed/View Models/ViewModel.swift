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
    @Published var current_user: User? = nil
    @Published var errorText: String? = nil
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    init() {
        let handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.setCurrentUser(userId: user.uid)
            } else {
                UserDefaults.standard.setValue(false, forKey: "log_Status")
            }
        }
    }
    
    func firebase_sign_out() {
        do {
            try auth.signOut()            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func firebase_email_password_sign_up(email: String, password: String, username: String, displayName: String, phoneNumber: String) {
        
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorText = error.localizedDescription
                return
            }
        }
    }
    
    func firebase_sign_in(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorText = error.localizedDescription
            }
        }
    }
    
    func setCurrentUser(userId: String) {
        db.collection("USERS").document(userId).getDocument (completion: { [weak self] document, error in
            if let error = error {
                self?.errorText = error.localizedDescription
            } else if let document = document {
                self?.current_user = User(id: userId,
                                          name: document["name"] as! String,
                                          username: document["username"] as! String,
                                          profilePicture: document["profilePicture"] as! String,
                                          email: document["email"] as! String,
                                          favorites: document["favorites"] as! [Post],
                                          friends: document["friends"] as! [User],
                                          savedPosts: document["savedPosts"] as! [Post],
                                          bio: document["bio"] as! String,
                                          myPosts: document["myPosts"] as! [Post],
                                          phoneNumber: Int(document["phone_number"] as! String)!,
                                          location: document["location"] as! String,
                                          myRecipes: document["myRecipes"] as! [String])
                UserDefaults.standard.setValue(true, forKey: "log_Status")
            }
        })
    }
}
