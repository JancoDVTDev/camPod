//
//  User.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/27.
//

import Foundation
import FirebaseDatabase

public class User {

    public var name: String?
    public var surname: String?
    public var email: String
    public var password: String
    
    public var UID: String?
    public var albums: [Album]?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        
        //Log user in with firebase and retrieving the data to set the other variables inside this class
        //Func - Login
    }
    
    init(name: String, and surname: String, with email: String, and password: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
        //Create new user with firebase
//        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
//            //check for errors
//            if err != nil {
//                //There was error creating the user
//                self.showError("Error creating user")
//            } else {
//                //User was created succesfull
//                let firebaseDb = Firestore.firestore()
//                firebaseDb.collection("users").addDocument(data: [
//                    "firstName": firstName,
//                    "lastName": lastName,
//                    "uid": result!.user.uid]) { (errOne) in
//                    if errOne != nil {
//                        self.showError("User couldn't be saved")
//                    }
//                }
//                // Transition to the home screen
//                self.transitionToHome()
//            }
//        }
    }
}

public class album {
    public var albumName: String
    public var images: [UIImage]?
    
    public init(name: String, images: [UIImage]?) {
        self.albumName = name
        self.images = images
    }
    
    public func appendImageToAlbum(image: UIImage) {
        images?.append(image)
    }
}
