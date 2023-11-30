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
    
    @ObservedObject var imageLoader = ImageLoader()
    @ObservedObject var locationManager = LocationManager()
    
    @Published var current_user: User? = nil
    @Published var errorText: String? = nil
    
    @Published var comments: [Comment] = [Comment]()
    @Published var usernameSearchResults: [String] = [String]()
    
    // POSTS
    @Published var my_post_today: Post?
    @Published var todays_posts: [Post] = [Post]() {
        didSet {
            print("todays post did set called")
            my_post_today = nil
            if let currentUserID = self.current_user?.id,
               let index = todays_posts.firstIndex(where: { $0.userID == currentUserID }) {
                my_post_today = todays_posts.remove(at: index)
                print("todays post updated")
                
            }
        }
    }
    
    
    // camera stuff (DONT USE)
    @Published var photo_1: UIImage?
    @Published var photo_2: UIImage?
    @Published var bothImagesCaptured = false
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    let storageRef = Storage.storage().reference()
    
    let dateFormatter = DateFormatter()
    let dayFormatter = DateFormatter()
    
    // remove later
    init(photo1: UIImage? = nil, photo2: UIImage? = nil) {
        self.photo_1 = photo1
        self.photo_2 = photo2
    }
    
    init() {
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dayFormatter.dateFormat = "MM-dd-yyyy"
        
        _ = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                print("User Found")
                if let username = user.displayName {
                    print("Setting User: \(username)")
                    self?.setCurrentUser(userId: username) {
                        UserDefaults.standard.setValue(true, forKey: "log_Status")
                        
                        self?.refreshFeed {
                            // do nothing
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
                     "profilePicture" : "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png", // default icon
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
                        } else {
                            self?.setCurrentUser(userId: username) {
                                UserDefaults.standard.setValue(true, forKey: "log_Status")
                            }
                        }
                    }
            }
        }
    }
    
    func firebase_sign_in(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
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
                                          requests: document["incomingRequests"] as! [String],
                                          pins: document["pins"] as? [String] ?? [],
                                          myPosts: document["myPosts"] as! [String])
                completion()
            }
        })
    }
    
    func refreshFeed(_ completion: @escaping () -> Void) {
        get_todays_posts() { postIDs in
            // Create post models
            self.todays_posts.removeAll()
            self.fetchPosts(postIDs: postIDs) { posts in
                self.todays_posts = posts
                completion()
            }
        }
    }
    
    func fetchPosts(postIDs: [String], completion: @escaping ([Post]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var posts: [Post] = [Post]()
        
        for postID in postIDs {
            print("Entering dispatch group for post ID: \(postID)")
            dispatchGroup.enter()
            
            self.db.collection("POSTS").document(postID).getDocument { [weak self] document, error in
                defer {
                    print("Leaving dispatch group for post ID: \(postID)")
                }
                
                if let error = error {
                    self?.errorText = "Error fetching post with ID \(postID): \(error.localizedDescription)"
                } else if let document = document, document.exists {
                    let data = document.data()!
                    
                    self?.getFriend(userID: data["userID"] as! String) { friend in
                        self?.get_post_comments(postID: postID, completion: { comments in
                            self?.get_post_recipes(postID: postID, completion: { recipes in
                                print("FOUND FRIEND \(friend.name)")
                                posts.append(Post(
                                    id: document.documentID,
                                    userID: data["userID"] as! String,
                                    images: data["images"] as! [String],
                                    date: data["date"] as! [String],
                                    day: data["day"] as! String,
                                    comments: comments,
                                    caption: data["caption"] as? [String] ?? [],
                                    likes: data["likes"] as? [String] ?? [],
                                    locations: data["location"] as? [String] ?? [],
                                    recipes: recipes,
                                    friend: friend
                                ))
                                // Notify that this specific task is complete
                                dispatchGroup.leave()
                            })
                        })
                    }
                } else {
                    // Notify that this specific task is complete even if there is an error
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All tasks completed")
            completion(posts)
        }
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
    
    func firebase_delete_comment(post: Post, comment: Comment, completion: @escaping (Bool) -> Void) {
        self.db.collection("POSTS").document(post.id).collection("COMMENTS").document(comment.id).delete { err in
            if let err = err {
                print("Error: \(err.localizedDescription)")
                completion(false)
            } else {
                // comment deleted
                // UI Changes
                completion(true)
                
            }
        }
    }
    
    func firebase_get_post(postID: String, completion: @escaping ((Post) -> Void)) {
        db.collection("POSTS").document(postID).getDocument { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                
                guard let doc = document, doc.exists else { print("doc not found"); return }
                print(doc.documentID)
                if let data = doc.data() {
                    self.getFriend(userID: data["userID"] as! String) { friend in
                        print("3")
                        self.get_post_comments(postID: postID) { comments in
                            self.get_post_recipes(postID: postID) { recipes in
                                let post = Post(id: doc.documentID,
                                                userID: data["userID"] as! String,
                                                images: data["images"] as! [String],
                                                date: data["date"] as! [String],
                                                day: data["day"] as! String,
                                                comments: comments,
                                                caption: data["caption"] as? [String] ?? [],
                                                likes: data["likes"] as? [String] ?? [],
                                                locations: data["location"] as? [String] ?? [],
                                                recipes: recipes,
                                                friend: friend
                                )
                                completion(post)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func firebase_add_comment(postID: String, text: String, date: Date, completion: @escaping (Bool) -> Void) {
        
        let comment_id = UUID()
        let dateString = self.dateFormatter.string(from: date)
        
        self.db.collection("POSTS").document(postID).collection("COMMENTS").document(comment_id.uuidString).setData(
            ["id": comment_id.uuidString,
             "user_id" : current_user!.id,
             "text": text,
             "date": dateString,
             "profilePicture" : current_user!.profilePicture,
             "replies": []
            ] as [String : Any]
        ) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func firebase_add_recipe(postID: String, recipe: Recipe, recipe_id: String, completion: @escaping (Bool) -> Void) {
        self.db.collection("POSTS").document(postID).collection("RECIPES").document(recipe_id).setData(
            ["id": recipe_id,
             "title": recipe.title,
             "link": recipe.link ?? "",
             "ingredients": recipe.ingredients ?? "",
             "directions": recipe.directions ?? ""
            ] as [String: Any]
        ) { error in
            if let error = error {
                print("Error adding recipe: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
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
    
    
    func publish_post(caption: String, location: String, recipe: Recipe?, completion: @escaping (Bool) -> Void) {
        let date = Date()
        // add logic to check if first post of today
        // for now just create new document
        
        let dateFormatted = dateFormatter.string(from: date) // get string from date
        let dayFormatted = dayFormatter.string(from: date) // get string from date
        
        self.firebase_get_url_from_image(image: self.photo_1!) { url_1 in
            if url_1 == nil {
                print("Error uploading photo_1")
                completion(true)
                return
            } else {
                print("URL_1: \(url_1?.absoluteString)")
            }
            self.firebase_get_url_from_image(image: self.photo_2!) { url_2 in
                
                if url_2 == nil {
                    print("Error uploading photo_2")
                    completion(true)
                    return
                }
                
                if let foodPic = url_1 {
                    if let selfie = url_2 {
                        let recipeId = (recipe != nil) ? UUID().uuidString : ""
                        
                        let docId = UUID()
                        
                        let data = ["id" : docId.uuidString,
                                    "userID" : self.current_user!.id,
                                    "images" : ["\(foodPic) \(selfie)"],
                                    "caption" : [caption],
                                    "recipes" : [recipeId],
                                    "date" : [dateFormatted],
                                    "day" : dayFormatted,
                                    "likes" : [],
                                    "comments" : [],
                                    "location" : [location]]
                        as [String : Any]
                        
                        if let myPostToday = self.my_post_today {
                            self.firebase_add_entry_post(
                                selfie: selfie.absoluteString,
                                foodPic: foodPic.absoluteString,
                                caption: caption,
                                recipe: recipeId,
                                location: location) { done in
                                    // if entry upload is done, show camera view sheet should close (false)
                                    completion(!done)
                                }
                        } else {
                            self.db.collection("POSTS").document(docId.uuidString).setData(data) { error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription) ")
                                    completion(true)
                                } else {
                                    self.db.collection("USERS").document(self.current_user!.id).updateData(["myPosts": FieldValue.arrayUnion([docId.uuidString])])
                                    completion(false)
                                }
                            }
                        }
                        
                        if let recipe = recipe {
                            self.firebase_add_recipe(postID: self.my_post_today?.id ?? docId.uuidString, recipe: recipe, recipe_id: recipeId) {_ in
                                print("Added recipe \(recipeId) to postID: \(docId.uuidString)")
                            }
                        }
                    }
                }
                
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
                print("\(documents!.count) comments found")
                print()
                for document in documents!.documents {
                    let data = document.data()
                    print("doc ID: \(document.documentID)")
                    do {
                        let comment = try Comment(id: data["id"] as! String, userID: data["user_id"] as! String, text: data["text"] as! String, date: self.dateFormatter.date(from: data["date"] as! String)!, profilePicture: data["profilePicture"] as! String)
                        comments.append(comment)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
            completion(comments)
        }
    }
    
    func get_post_recipes(postID: String, completion: @escaping ([Recipe?]) -> Void) {
            var recipeIDs: [String] = []

            let idRef = self.db.collection("POSTS").document(postID)
            idRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting recipes \(error.localizedDescription)")
                    completion([])
                } else {
                    if let doc = document, let data = doc.data() {
                        recipeIDs = data["recipes"] as? [String] ?? []
                    }
                    let dispatchGroup = DispatchGroup()
                    var recipes: [Recipe?] = Array(repeating: nil, count: recipeIDs.count)

                    for (index, recipeID) in recipeIDs.enumerated() {
                        dispatchGroup.enter()

                        if recipeID.isEmpty {
                            dispatchGroup.leave()
                        } else {
                            let recipesRef = self.db.collection("POSTS").document(postID).collection("RECIPES").document(recipeID)
                            recipesRef.getDocument { (document, error) in
                                defer {
                                    dispatchGroup.leave()
                                }

                                if let error = error {
                                    print("Error in getting recipe with id: \(recipeID)")
                                } else {
                                    if let doc = document, let data = doc.data() {
                                        let recipe = Recipe(
                                            id: data["id"] as? String ?? "",
                                            title: data["title"] as? String ?? "",
                                            link: (data["link"] as? String)?.isEmpty == true ? nil : data["link"] as? String,
                                            ingredients: (data["ingredients"] as? [String])?.isEmpty == true ? nil : data["ingredients"] as? [String],
                                            directions: (data["directions"] as? String)?.isEmpty == true ? nil : data["directions"] as? String
                                        )
                                        recipes[index] = recipe
                                    } else {
                                        print("Error getting data for recipe with id \(recipeID)")
                                    }
                                }
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        completion(recipes)
                    }
                }
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
    
    
    
    
    
    func firebase_add_entry_post(selfie: String, foodPic: String, caption: String, recipe: String, location: String, completion: @escaping (Bool) -> Void) {
        let date = Date()
        let entry_date = dateFormatter.string(from: date)
        
        if let id = self.my_post_today?.id {
            self.db.collection("POSTS").document(id).getDocument { (document, error) in
                if let doc = document {
                    if let data = doc.data() {
                        // ADD NEW DATE FIELD
                        self.db.collection("POSTS").document(id).updateData(["date": FieldValue.arrayUnion([entry_date])])
                        
                        var myCaptions = []
                        myCaptions = data["caption"] as! [String]
                        myCaptions.append(caption)
                        self.db.collection("POSTS").document(id).updateData(["caption": myCaptions])
                        
                        var imagesArr = []
                        imagesArr = data["images"] as! [String]
                        imagesArr.append("\(foodPic) \(selfie)")
                        self.db.collection("POSTS").document(id).updateData(["images": imagesArr])
                        
                        var locationArr = []
                        locationArr = data["location"] as! [String]
                        locationArr.append(location)
                        self.db.collection("POSTS").document(id).updateData(["location": locationArr])
                        
                        var recipeArr = []
                        recipeArr = data["recipes"] as! [String]
                        recipeArr.append(recipe)
                        self.db.collection("POSTS").document(id).updateData(["recipes": recipeArr])
                        
                        completion(true)
                    } else {
                        print("Document does not exist")
                        completion(false)
                    }
                } else {
                    print("Document does not exist")
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    
    
    
    
    func get_todays_posts(completion: @escaping ([String]) -> Void) {
        print("GET TODAYS POST TOP")
        
        let date = Date()
        
        let dateFormatterSimple = DateFormatter()
        dateFormatterSimple.dateFormat = "MM-dd-yyyy"
        
        let dateTodayString = dateFormatterSimple.string(from: date)
        
        var postList: [String] = [String]()
        
        get_friends_ids() { friends in
            var allUsersToFetch = friends
            allUsersToFetch.append(self.current_user!.id)
            
            self.db.collection("POSTS").whereField("userID", in: allUsersToFetch).whereField("day", isEqualTo: dateTodayString).getDocuments() {documents, err in
                if let err = err {
                    // Unable to get posts, error screen
                    print("In Get Todays Posts: \(err.localizedDescription)")
                } else {
                    print("GET TODAYS POST BOTTOM")
                    for document in documents!.documents {
                        postList.append(document.documentID)
                        print("Document found: \(document.documentID)")
                    }
                    print("DONE")
                    completion(postList)
                    
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
                        let currentUserFriends = Set(self.current_user!.friends.map { $0 })
                        let user2FriendIDs = Set((data["friends"] as? [String] ?? []).map { $0 })

                        // Find mutual friends by taking the intersection of the two sets
                        let mutualFriendIDs = Array(currentUserFriends.intersection(user2FriendIDs))
                        var friendsPostToday: String? = self.todays_posts.first(where: { $0.userID == document.documentID })?.id

                        friends.append(Friend(id: document.documentID,
                                              name: data["name"] as? String ?? "Name not Found",
                                              profilePicture: data["profilePicture"] as? String ?? "Profile picture not found",
                                              bio: data["bio"] as? String ?? "",
                                              mutualFriends: mutualFriendIDs,
                                              pins: data["pins"] as? [String] ?? [],
                                              todaysPost: friendsPostToday))
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
                    var friendsPostToday: String? = self.todays_posts.first(where: { $0.userID == userID })?.id
                    
                    completion(Friend(id: document.documentID,
                                      name: data["name"] as? String ?? "Name not Found",
                                      profilePicture: data["profilePicture"] as? String ?? "Profile picture not found",
                                      bio: data["bio"] as? String ?? "",
                                      mutualFriends: [],
                                      pins: data["pins"] as? [String] ?? [],
                                      todaysPost: friendsPostToday))
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
                        //make sure current user doesn't show up in suggestions
                        let userid: Set<String> = [self.current_user!.id]
                        suggestions.subtract(userid)
                        self.get_friends(userIDs: Array(suggestions)) { friends in
                            completion(friends)
                        }
                    }
                }
            }
            
        }
    }
    
    func getUserProfilePic(userIDs: [String], completion: @escaping ([URL]) -> Void) {
        var pics: [URL] = []
        var dispatchGroup = DispatchGroup()
        for userID in userIDs {
            dispatchGroup.enter()
            self.db.collection("USERS").document(userID).getDocument { document, error in
                defer {
                    dispatchGroup.leave()
                }
                if let err = error {
                    print("Error getting profile picture")
                } else if let doc = document {
                    if let data = doc.data() {
                        pics.append(URL(string: (data["profilePicture"] as? String ?? "")) ?? URL(string: "https://static-00.iconduck.com/assets.00/person-crop-circle-icon-256x256-02mzjh1k.png")!)
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(pics)
        }
    }
    
    func getUserPosts(userID: String, completion: @escaping ([Post]) -> Void) {
        var postArr : [Post] = []
        self.db.collection("USERS").document(userID).getDocument { document, error in
            if let err = error {
                print("Error getting user's posts \(err.localizedDescription)")
            } else {
                if let doc = document, let data = doc.data() {
                    var postIDs = data["myPosts"] as? [String] ?? []
                    self.fetchPosts(postIDs: postIDs) { posts in
                        completion(posts)
                    }
                } else {
                    print("error getting user document \(userID)")
                }
            }
        }
    }
    
    
    
    
    func convertToComments(postID: String) -> [Comment] {
        var comment: [Comment]?
        
        self.db.collection("POSTS").document(postID).collection("COMMENTS").getDocuments(completion: { [weak self] documents, error in
            if let error = error {
                self?.errorText = "Cannot get list of comments from Firebase."
            } else {
                for document in documents!.documents {
                    comment?.append(Comment(id: document.documentID,
                                            userID: document["userID"] as! String,
                                            text: document["text"] as! String,
                                            date: self?.dayFormatter.date(from: document["date"] as! String)  ?? Date(),
                                            profilePicture: document["profilePicture"] as! String,
                                            replies: document["directions"] as? [Comment] ?? []
                                           ))
                    UserDefaults.standard.setValue(true, forKey: "log_Status")
                }
            }
        })
        return comment ?? []
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
        DispatchQueue.main.async {
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
    }
    
    // returns post ID
    func get_post_from_day(day: String, completion: @escaping (String) -> Void) {
        db.collection("POSTS").whereField("userID", isEqualTo: self.current_user!.id).whereField("day", isEqualTo: day).getDocuments(completion: { documents, error in
            if let err = error {
                print(err.localizedDescription)
                completion("")
            } else if let docs = documents?.documents {
                if docs.count == 1 {
                    if let postID = docs[0]["id"] as? String {
                        print(postID)
                        completion(postID)
                    } else {
                        completion("")
                    }
                } else {
                    completion("")
                }
                completion("")
            } else {
                completion("")
            }
        })
        
        
        
    }
    
    //synchronous approach
    func load_image_from_url(url: String) -> Image? {
        if (url == "NIL" || url.isEmpty) {
            return nil
        }
        guard let url = URL(string: url) else { return nil }
        
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        if let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
        
    }
    
    
    func firebase_add_pin(postID: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("USERS").document(self.current_user!.id)
        
        docRef.updateData(
            ["pins" : FieldValue.arrayUnion([postID])] // append pins
        ) { err in
            if let err = err {
                print(err.localizedDescription)
                completion(false) // not added
            } else {
                print("Added Pin")
                self.current_user?.pins.append(postID)
                completion(true)
            }
        }
    }
    
    func firebase_remove_pin(postID: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("USERS").document(self.current_user!.id)
        
        docRef.updateData(
            ["pins" : FieldValue.arrayRemove([postID])] // remove pins
        ) { err in
            if let err = err {
                print(err.localizedDescription)
                completion(false) // not removed
            } else {
                print("Removed Pin")
                self.current_user?.pins.removeAll(where: { id in
                    id == postID
                })
                completion(true)
            }
        }
    }
    
    func updateUserField(field: String, value: String) {
        db.collection("USERS").document(current_user!.id).updateData(
            [field: value]) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    self.setCurrentUser(userId: self.current_user!.id) {
                        
                    }
                }
            }
    }
    
    func firebase_search_for_friends(username: String, completionHandler: @escaping (([Friend]) -> Void)) {
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
                self.get_friends(userIDs: arr) { friends in
                    print(friends.count)
                    
                    completionHandler(friends)
                }
            }
    }
}
