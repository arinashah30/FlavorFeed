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
import FirebaseStorage
import SwiftUI


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
    
    @Published var todays_posts: [Post] = [Post]()
    
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    let storageRef = Storage.storage().reference()
    

    
    init() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                print("User Found")
                if let username = user.displayName {
                    print("Setting User: \(username)")
                    self?.setCurrentUser(userId: username) {
                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                        self?.get_todays_posts() { postIDs in
                            // Create post models
                            
                            for id in postIDs {
                                print("get post object for \(id)")
                                self?.firebase_get_post(postID: id) { post in
                                    self?.todays_posts.append(post)
                                    print("New feed size: \(String(describing: self?.todays_posts.count))")

                                }
                            }
                            
                        }
                    }
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
                     "incomingRequests": [],
                     "outgoingRequests": [],
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
        let fromRef = self.db.collection("USERS").document(from)
        let toRef = self.db.collection("USERS").document(to)
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
    
    
    func setCurrentUser(userId: String, completion: @escaping (() -> Void)) {
        db.collection("USERS").document(userId).getDocument (completion: { [weak self] document, error in
            if let error = error {
                print("SetCurrentUserError: \(error.localizedDescription)")
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
                completion()
            }
        })
    }
    
    func accept_friend_request(from: String, to: String) {
        let fromRef = self.db.collection("USERS").document(from)
        let toRef = self.db.collection("USERS").document(to)
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
        let fromRef = self.db.collection("USERS").document(from)
        let toRef = self.db.collection("USERS").document(to)
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
        self.db.collection("POSTS").document(post.id).collection("COMMENTS").document(comment.id).delete { err in
            if let err = err {
                print("Error: \(err.localizedDescription)")
            } else {
                // comment deleted
                // UI Changes
                
            }
        }
    }
    func firebase_get_post(postID: String, completion: @escaping ((Post) -> Void)) {
        print("Getting post...")
        db.collection("POSTS").document(postID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                if let doc = document {
                    if let data = doc.data() {
                        completion(Post(id: doc.documentID,
                                 userID: data["userID"] as! String,
                                 images: data["images"] as! [String],
                                 date: data["date"] as! [String],
                                 day: data["day"] as! String,
                                 comments: self.convertToComments(data["comments"] as? [String] ?? []),
                                 caption: data["caption"] as? [String] ?? [],
                                 likes: data["likes"] as? [String] ?? [],
                                 locations: data["locations"] as? [String] ?? [],
                                 recipes: self.convertToRecipe(data["recipes"] as? [String] ?? [])))
                    }
                }
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
        let postRef = self.db.collection("POSTS").document(post.id)
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
        let postRef = self.db.collection("POSTS").document(post.id)
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
  
    func firebase_create_post(userID: String, selfie: String, foodPic: String, caption: String, recipe: String, location: String) {
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let dateFormatted = dateFormatter.string(from: date) // get string from date
        
        
        let docId = UUID()
    
        
        let data = ["id" : docId.uuidString,
                    "userID" : userID,
                    "images" : [selfie, foodPic],
                    "caption" : [caption],
                    "recipe" : [recipe],
                    "date" : [dateFormatted],
                    "likes" : [],
                    "location" : [location]]
        as [String : Any]
        
        self.db.collection("POSTS").document(docId.uuidString).setData(data) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            } else {
                self.db.collection("USERS").document(userID).updateData(["myPosts": FieldValue.arrayUnion([docId.uuidString])])
            }
        
        }
    }
    func firebase_search_for_username(username: String, completionHandler: @escaping (([String]) -> Void)) {
        var arr: [String] = []
        self.db.collection("USERS").whereField("id", isGreaterThanOrEqualTo: username).whereField("id", isLessThanOrEqualTo: username + "\u{f7ff}")
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        arr.append(data["id"] as! String)
                    }
                }
                completionHandler(arr)
            }
            
    }

    
    func get_todays_posts(completion: @escaping ([String]) -> Void) {
        let date = Date()
        
        let dateFormatterSimple = DateFormatter()
        dateFormatterSimple.dateFormat = "MM-dd-yyyy"
        
        let dateTodayString = dateFormatterSimple.string(from: date)
        
        var postList: [String] = [String]()
        get_friends() { friends in
            if friends.isEmpty {
                // Problem getting friends, error screen
            } else {
                self.db.collection("POSTS").whereField("userID", in: friends).whereField("day", isEqualTo: dateTodayString).getDocuments() {documents, err in
                    if let err = err {
                        // Unable to get posts, error screen
                        print("In Get Todays Posts: \(err.localizedDescription)")
                    } else {
                        for document in documents!.documents {
                            postList.append(document.documentID)
                            print(document.documentID)
                        }
                        completion(postList)

                    }
                }
            }
            
        }
    }
    
    func get_friends(completion: @escaping ([String]) -> Void) {
        let userRef = self.db.collection("USERS").document(current_user!.id)
        userRef.getDocument { document, err in
            if let err = err  {
                print("In Get Friends: \(err.localizedDescription)")
                completion([])
            } else {
                let data = document!.data()!
                let friends = data["friends"] as? [String]
                completion(friends!)
            }
        }
    }
    
    // needs to be done
    func convertToRecipe(_ recipesString: [String]) -> [Recipe] {
        return [Recipe]()
    }
    
    // needs to be done
    func convertToComments(_ commentsString: [String]) -> [Comment] {
        return [Comment]()
    }
    
    func firebase_get_url_from_image(image: UIImage, completion: @escaping (URL?) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(nil)
                return
            }
            // create random image path
            let imagePath = "images/\(UUID()).jpg"
            
            // create reference to file you want to upload
            let imageRef = storageRef.child(imagePath)
            
            //upload image
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    // Image successfully uploaded
                    imageRef.downloadURL { url, error in
                        if let downloadURL = url {
                            completion(downloadURL)
                        } else {
                            print("Error getting download URL: \(String(describing: error?.localizedDescription))")
                        }
                    }
                }
            }
        }
        
        //synchronous approach
        func load_image_from_url(url: String) -> Image? {
            if url == "NIL" {
                return nil
            }
            let url = URL(string: url)!
            
            guard let imageData = try? Data(contentsOf: url),
                  let uiImage = UIImage(data: imageData) else {
                return nil
            }
            return Image(uiImage: uiImage)
        }
}
