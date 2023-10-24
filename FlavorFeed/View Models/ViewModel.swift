//
//  ViewModel.swift
//  FlavorFeed
//
//  Created by Nicholas Candello on 10/4/23.
//

// Testing something out.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewModel: ObservableObject {
    @Published public var current_user: User? = nil
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
  


    // Function to save the user's information
    func saveInfo() {
        
    }
    
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
                        print("Error: \(error?.localizedDescription)")
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
    

    func getInformation(){
        if let user = current_user {
            db.collection("USERS").document(user.id).getDocument { document, error in
                if let error = error {
                    print("Error getting user information: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    if let data = document.data() {

                        if let bio = data["bio"] as? String {
                            self.current_user!.bio = bio
                        }
                        if let email = data["email"] as? String {
                            self.current_user!.email = email
                        }
                        if let name = data["name"] as? String {
                            self.current_user!.name = name
                        }
                        if let phoneNumber = data["phone_number"] as? Int{
                            self.current_user!.phoneNumber = phoneNumber
                        }
                        if let username = data["username"] as? String {
                            self.current_user!.username = username
                        }
                        
                    }
                }
            }
        }
    }


    func updateUser(bio: String, email: String, name: String, phoneNumber: String, username: String)
    {
        if let userID = auth.currentUser?.uid {
            db.collection("USERS").document("\(userID)").updateData(["bio": bio, "email": email, "name": name, "phone_number": phoneNumber, "username": username])
        } else {
            print("error")
        }
    }
}
