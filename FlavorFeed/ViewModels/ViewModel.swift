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


/**
 View Model Directory:
 
Firebase Methods:
1. firebase_sign_out
2. firebase_email_password_sign_up
3. firebase_sign_in
4. send_friend_request
5. setCurrentUser
6. accept_friend_request
7. reject_friend_request
8. firebase_delete_comment
9. firebase_add_comment
 
 
 **/

class ViewModel: ObservableObject {
    
    @Published var current_user: User? = nil 
    @Published var errorText: String? = nil
    
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    

    
    init() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                print("User Found")
                if let username = user.displayName {
                    print("Setting User: \(username)")
                    self?.setCurrentUser(userId: username)
                    UserDefaults.standard.setValue(true, forKey: "log_Status")
                }
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
                let firebaseError = AuthErrorCode.Code(rawValue: error._code)
                switch firebaseError {
                case .emailAlreadyInUse:
                    self?.errorText = "An account with this email already exists"
                case .weakPassword:
                    self?.errorText = "This password is too weak"
                default:
                    self?.errorText = "An error has occurred"
                }
            } else if let user = authResult?.user {
                print("UPDATING DISPLAY NAME")
                let changeRequest = user.createProfileChangeRequest()
                print(username)
                changeRequest.displayName = username
                changeRequest.commitChanges { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                self?.db.collection("USERS").document(username).setData(
                    ["id" : username,
                     "name" : displayName,
                     "profilePicture" : "",
                     "email" : email,
                     "bio" : "",
                     "phone_number" : phoneNumber,
                     "friends" : [],
                     "pins" : [],
                     "myPosts" : []
                    ] as [String : Any]) { error in
                        if let error = error {
                            self?.errorText = error.localizedDescription
                        }
                    }
            }
        }
    }
    
    func firebase_sign_in(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print(error._code)
                let firebaseError = AuthErrorCode.Code(rawValue: error._code)
                switch firebaseError {
                case .wrongPassword:
                    self?.errorText = "Password incorrect"
                case .userNotFound:
                    self?.errorText = "User not found"
                case .userDisabled:
                    self?.errorText = "Your account has been disabled"
                default:
                    self?.errorText = "An error has occurred"
                }
            }
            
        }
    }
    
    func send_friend_request(from: String, to: String) {
        var fromRef = self.db.collection("USERS").document(from)
        var toRef = self.db.collection("USERS").document(to)
        fromRef.updateData([
            "outgoingRequests": FieldValue.arrayUnion([to])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
        toRef.updateData([
            "incomingRequests": FieldValue.arrayUnion([from])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
                
            }
        }
    }
    
    
    func setCurrentUser(userId: String) {
        db.collection("USERS").document(userId).getDocument (completion: { [weak self] document, error in
            if let error = error {
                self?.errorText = error.localizedDescription
            } else if let document = document {
                self?.current_user = User(id: document.documentID,
                                          name: document["name"] as! String,
                                          profilePicture: document["profilePicture"] as! String,
                                          email: document["email"] as! String,
                                          bio: document["bio"] as! String,
                                          phoneNumber: document["phone_number"] as! String,
                                          friends: document["friends"] as! [String],
                                          pins: document["pins"] as? [String] ?? [],
                                          myPosts: document["myPosts"] as! [String])
                UserDefaults.standard.setValue(true, forKey: "log_Status")
            }
        })
    }
    
    func accept_friend_request(from: String, to: String) {
        var fromRef = self.db.collection("USERS").document(from)
        var toRef = self.db.collection("USERS").document(to)
        fromRef.updateData([
            "outgoingRequests": FieldValue.arrayRemove([to]),
            "friends": FieldValue.arrayUnion([to])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
        toRef.updateData([
            "incomingRequests": FieldValue.arrayRemove([from]),
            "friends": FieldValue.arrayUnion([from])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
    }
    
    func reject_friend_request(from: String, to: String) {
        var fromRef = self.db.collection("USERS").document(from)
        var toRef = self.db.collection("USERS").document(to)
        fromRef.updateData([
            "outgoingRequests": FieldValue.arrayRemove([to])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
        toRef.updateData([
            "incomingRequests": FieldValue.arrayRemove([from])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
    }
    
    func firebase_delete_comment(post: Post, comment: Comment) {
        self.db.collection("POSTS").document(post.id).collection("comments").document(comment.id).delete { err in
            if let err = err {
                print("Error: \(err.localizedDescription)")
            } else {
                // comment deleted
                // UI Changes
                
            }
        }
        
        
    }
    
    func firebase_add_comment(post: Post, text: String, date: String) {

            let id = UUID()

            self.db.collection("POSTS").document(post.id).collection("COMMENTS").document(id.uuidString).setData(
                ["id": id.uuidString,
                 "user_id" : current_user!.id,
                 "text": text,
                 "date": date,
                 "replies": []
                ] as [String : Any]
            ) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {



                }
            }

        }
    
    func firebase_like_post(post: inout Post, user: String) {
        var postRef = self.db.collection("POSTS").document(post.id)
        postRef.updateData([
            "likes": FieldValue.arrayUnion([user])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
    }
    
    func firebase_unlike_post(post: Post, user: String) {
        var postRef = self.db.collection("POSTS").document(post.id)
        postRef.updateData([
            "likes": FieldValue.arrayRemove([user])
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                // UI Changes
            }
        }
    }
  
    func firebase_create_post(images: String, caption: String, recipe: String, location: String) {
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        let dateFormatted = dateFormatter.string(from: date) // get string from date
        
        let data = ["images" : images,
                    "caption" : caption,
                    "recipe" : recipe,
                    "date" : dateFormatted,
                    "likes" : [],
                    "location" : location]
        as [String : Any]
        
        let docId = UUID()
        self.db.collection("POSTS").document(docId.uuidString).setData(data) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else {
                self.db.collection("USERS").document("1mLyRTekRPWRf2aJtmzYyaJQQqI2").updateData(["myPosts": FieldValue.arrayUnion([docId.uuidString])])
            }
        
        }
    }
    func firebase_search_for_username(username: String, completionHandler: @escaping (([String]) -> Void)) {
        var arr: [String] = []
        self.db.collection("USERS").whereField("username", isGreaterThanOrEqualTo: username).whereField("username", isLessThanOrEqualTo: username + "\u{f7ff}")
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        arr.append(data["username"] as! String)
                    }
                }
                completionHandler(arr)
            }
            
    }
    func sendBackList(username: String) -> [String] {
        var arr: [String] = []
        
        for num in 1...10 {
            arr.append("NewUsername\(username)")
        }
        return arr
    }
}
