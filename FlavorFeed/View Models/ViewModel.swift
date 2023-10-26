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
    @Published var post: Post? = nil
    @Published var searchResults: [String] = []
    
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
                        //print(data)
                        arr.append(data["username"] as! String)
//                        print(data)*/
//                        print("\(document.documentID) => \(document.data())")
                    }
                }
                completionHandler(arr)
            }
                
        
        /*let ref = self.db.collection("USERS").queryOrdered(byChild: "username").queryStarting(atValue: username).queryEnding(atValue: "\(username)\\uf8ff")
         ref.observeSingleEvent(of: .value) { (snapshot, error)  in
         guard let dictionaries = snapshot.value as? [String: Any]
         else { return }
         
         self.users.removeAll() // clear all previous results
         
         dictionaries.forEach({ (key, value) in
         
         if key == Auth.auth().currentUser?.uid {
         return
         }
         
         guard let userDictionary = value as? [String: Any] else { return }
         
         let user = User(uid: key, dictionary: userDictionary)
         self.users.append(user)
         
         })
         
         self.users.sort(by: { (user1, user2) -> Bool in
         
         return user1.username.compare(user2.username) == .orderedAscending
         })*/
    }
    func sendBackList(username: String) -> [String] {
        var arr: [String] = []
        
        for num in 1...10 {
            arr.append("NewUsername\(username)")
        }
        return arr
    }
}
