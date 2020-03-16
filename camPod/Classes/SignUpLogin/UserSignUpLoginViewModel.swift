//
//  UserSignUpLoginViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation
import FirebaseAuth

protocol UserSignUpLoginViewModelProtocol {
    func signUp(name: String, and surname: String, with email: String, and password: String,
    _ completion: @escaping (_ val: Bool) -> ())
    func login(email: String, password: String, completion: @escaping (_ val: Bool) -> ())
}

public class UserSignUpLoginViewModel {
    var currentUserData = UserModel()
    public init() {
        
    }
    
    public func signUp(name: String, and surname: String, with email: String, and password: String,
                       _ completion: @escaping (_ val: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            print("User signed out")
        }catch {
            print("Print error Signing out")
        }
        let currentUser = UserModel(name: name, and: surname, with: email, and: password)
        currentUser.createUser {_ in
            print("User signed in from signUp")
            self.currentUserData = currentUser
            completion(true)
        }
        
    }
    
    public func login(email: String, password: String, completion: @escaping (_ val: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            print("User signed out")
        }catch {
            print("Print error Signing out")
        }
        let currentUser = UserModel(email: email, password: password)
        currentUser.signIn {_ in
            print("User signed in from login")
            self.currentUserData = currentUser
            completion(true)
        }
    }
    
    public func getUserAlbumNames() -> [String] {
        if let albumNames = currentUserData.albumNames {
            return albumNames
        } else {
            return [""]
        }
    }
}
