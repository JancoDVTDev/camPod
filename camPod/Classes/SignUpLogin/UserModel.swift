//
//  UserModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

public class UserModel {

    public var name: String?
    public var surname: String?
    public var email: String
    public var password: String
    
    public var UID: String?
    public var albums: [Album]?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                
            }
        }
        //Log user in with firebase and retrieving the data to set the other variables inside this class
        //Func - Login
    }
    
    init(name: String, and surname: String, with email: String, and password: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                let ref = Database.database().reference()
                self.UID = result?.user.uid
                ref.child("Users").childByAutoId().setValue([
                    "firstName" : name,
                    "surname": surname,
                    "uid": result!.user.uid]) 
            }
        }
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
