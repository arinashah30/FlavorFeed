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
    @Published var comments: [Comment] = [Comment]()
    @Published var usernameSearchResults: [String] = [String]()

    
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
    
    func fetchPosts(postIDs: [String]) -> [Post]{
        var post: [Post]?
        post = nil
        self.db.collection("POSTS").whereField("id", in: postIDs).getDocuments(completion: { [weak self] documents, error in
                if let error = error {
                    self?.errorText = "Cannot get list of posts from Firebase: \(error.localizedDescription)"
                } else {
                    for document in documents!.documents {
                        post?.append(Post(id: document.documentID,
                                          userID: document["userID"] as! String,
                                          images: document["images"] as! [String],
                                          date: document["date"] as! [String],
                                          day: document["day"] as! String,
                                          comments: document["comments"] as? [Comment] ?? [],
                                          caption: document["caption"] as? [String] ?? [],
                                          likes: document["likes"] as? [String] ?? [],
                                          locations: document["locations"] as? [String] ?? [],
                                          recipes: document["recipes"] as? [Recipe] ?? [],
                                          friend: nil))

                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                    }
                }
            })
        return post!
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
                        self.getFriend(userID: data["userID"] as! String) { friend in
                            completion(Post(id: doc.documentID,
                                            userID: data["userID"] as! String,
                                            images: data["images"] as! [String],
                                            date: data["date"] as! [String],
                                            day: data["day"] as! String,
                                            comments: self.convertToComments(postID: doc.documentID),
                                            caption: data["caption"] as? [String] ?? [],
                                            likes: data["likes"] as? [String] ?? [],
                                            locations: data["location"] as? [String] ?? [],
                                            recipes: self.convertToRecipe(postID: doc.documentID),
                                            friend: nil
                                           ))
                        }
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
        

        let data = ["images" : selfie + " " + foodPic,
                    "caption" : caption,
                    "recipes" : recipe,
                    "date" : dateFormatted,
                    "likes" : [],
                    "location" : location]
        as [String : Any]
      
        let docId = UUID()
        self.db.collection("POSTS").document(docId.uuidString).setData(data) { error in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
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

    
    func get_post_comments(postID: String, completion: @escaping ([Comment]) -> Void) {
        let commentsRef = self.db.collection("POSTS").document(postID).collection("COMMENTS")
        commentsRef.getDocuments() { (documents, error) in
            var comments: [Comment] = [Comment]()
            if let error = error {
                // Error getting comments
                print("Error in the get post comments: \(error.localizedDescription)")
            } else {
                for document in documents!.documents {
                    let data = document.data()
                    let comment = Comment(id: data["id"] as! String, userID: data["userID"] as! String, text: data["text"] as! String, date: data["date"] as! String)
                    comments.append(comment)
                }
            }
            completion(comments)
        }
    }
    
    func get_friend_requests(completion: @escaping ([Friend]) -> Void) {
        let userRef = self.db.collection("USERS").document(current_user!.id)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error in the get friend requests: \(error.localizedDescription)")
            } else {
                let data = document!.data()
                let requests = data!["incomingRequests"] as? [String]
                self.get_friends(userIDs: requests ?? []) { friends in
                    completion(friends)
                }
            }
        }
    }


    
    func firebase_add_entry_post(userID: String, selfie: String, foodPic: String, caption: String, recipe: String, location: String) {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let dateFormatted = dateFormatter.string(from: date)
        
        self.db.collection("USERS").document(userID).getDocument { (document, error) in
            var myPosts = []
            if let document {
                myPosts = document.data()!["myPosts"] as! [String]
              } else {
                print("Document does not exist")
              }
            let todayPostID = myPosts[myPosts.count - 1]
            self.db.collection("POSTS").document(todayPostID as! String).getDocument { (document, error) in
                if let document {
                    var myCaptions = []
                    myCaptions = document.data()!["caption"] as! [String]
                    myCaptions.append(caption)
                    self.db.collection("POSTS").document(todayPostID as! String).updateData(["caption": myCaptions])
                    self.db.collection("POSTS").document(todayPostID as! String).updateData(["date": FieldValue.arrayUnion([dateFormatted])])
                    
                    var imagesArr = []
                    imagesArr = document.data()!["images"] as! [String]
                    imagesArr.append(selfie)
                    imagesArr.append(foodPic)
                    self.db.collection("POSTS").document(todayPostID as! String).updateData(["images": imagesArr])
                    
                    var locationArr = []
                    locationArr = document.data()!["location"] as! [String]
                    locationArr.append(location)
                    self.db.collection("POSTS").document(todayPostID as! String).updateData(["location": locationArr])
                    
                    var recipeArr = []
                    recipeArr = document.data()!["recipe"] as! [String]
                    recipeArr.append(recipe)
                    self.db.collection("POSTS").document(todayPostID as! String).updateData(["recipe": recipeArr])
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    }
    


    
    func get_todays_posts(completion: @escaping ([String]) -> Void) {
        let date = Date()
        
        let dateFormatterSimple = DateFormatter()
        dateFormatterSimple.dateFormat = "MM-dd-yyyy"
        
        let dateTodayString = dateFormatterSimple.string(from: date)
        
        var postList: [String] = [String]()
        get_friends_ids() { friends in
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
    
    func get_friends_ids(completion: @escaping ([String]) -> Void) {
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
    
    func get_friends(userIDs: [String], completion: @escaping (([Friend])-> Void)) {
        if userIDs.isEmpty {
            completion([Friend]())
        } else {
            self.db.collection("USERS").whereField("id", in: userIDs).getDocuments { (documents, error) in
                if let error = error {
                    print("SetCurrentUserError: \(error.localizedDescription)")
                } else {
                    var friends: [Friend] = [Friend]()
                    for document in documents!.documents {
                        let data = document.data()
                        friends.append(Friend(id: document.documentID,
                                              name: data["name"] as? String ?? "Name not Found",
                                              profilePicture: data["profilePicture"] as? String ?? "Profile picture not found",
                                              bio: data["bio"] as? String ?? "",
                                              mutualFriends: [],
                                              pins: data["pins"] as? [String] ?? [],
                                              todaysPosts: []))
                    }
                    completion(friends)
                }
            }
        }
    }
    
    func getFriend(userID: String, completion: @escaping ((Friend)-> Void)) {
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let error = error {
                print("SetCurrentUserError: \(error.localizedDescription)")
            } else if let document = document {
                if let data = document.data() {
                    completion(Friend(id: document.documentID,
                                    name: data["name"] as? String ?? "Name not Found",
                                    profilePicture: data["profilePicture"] as? String ?? "Profile picture not found",
                                    bio: data["bio"] as? String ?? "",
                                    mutualFriends: [],
                                    pins: data["pins"] as? [String] ?? [],
                                    todaysPosts: []))
                }
            }
        }
    }
    
    func get_friend_suggestions(completion: @escaping ([Friend]) -> Void) {
        get_friends_ids() { friends in
            if friends.isEmpty {
                completion([Friend]())
            } else {
                self.db.collection("USERS").whereField("id", in: friends).getDocuments() {documents, err in
                    if let err = err {
                        // Unable to get posts, error screen
                        print("In Get Friend Suggestions: \(err.localizedDescription)")
                    } else {
                        var suggestions = Set<String>()
                        for document in documents!.documents {
                            let data = document.data()
                            let friends = data["friends"] as? [String]
                            suggestions.formUnion(friends!)
                        }
                        suggestions.subtract(friends)
                        self.get_friends(userIDs: Array(suggestions)) { friends in
                            completion(friends)
                        }
                    }
                }
            }
            
        }
    }
    
    // needs to be done
    func convertToRecipe(postID: String) -> [Recipe] {
        var recipe: [Recipe]?
        
        self.db.collection("POSTS").document(postID).collection("RECIPES").getDocuments(completion: { [weak self] documents, error in
                if let error = error {
                    self?.errorText = "Cannot get list of recipes from Firebase."
                } else {
                    for document in documents!.documents {
                        recipe?.append(Recipe(id: document.documentID,
                                          title: document["title"] as! String,
                                          link: document["link"] as? String ?? nil,
                                          ingredients: document["ingredients"] as! [String],
                                          directions: document["directions"] as! [String]
                                         ))
                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                    }
                }
            })
        return recipe!
    }
    
    // needs to be done
    func convertToComments(postID: String) -> [Comment] {
        var comment: [Comment]?
        
        self.db.collection("POSTS").document(postID).collection("COMMENTS").getDocuments(completion: { [weak self] documents, error in
                if let error = error {
                    self?.errorText = "Cannot get list of recipes from Firebase."
                } else {
                    for document in documents!.documents {
                        comment?.append(Comment(id: document.documentID,
                                          userID: document["userID"] as! String,
                                          text: document["text"] as! String,
                                          date: document["date"] as! String,
                                          replies: document["directions"] as? [Comment] ?? []
                                         ))
                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                    }
                }
            })
        return comment!
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

