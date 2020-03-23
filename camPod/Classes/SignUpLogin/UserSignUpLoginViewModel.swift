//
//  UserSignUpLoginViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation
import FirebaseAuth

public class UserSignUpLoginViewModel {
    
    public weak var repo: UserModelProtocol?
    public var actualRepo = UserModel()
    
    public var user: User!
    
    var helpingHand: ObjcHelper = ObjcHelper()
    
    public init(repo: UserModelProtocol) { //
        self.repo = repo
    }
    
    public func login(with email: String, and password: String,
                      _ compeltion: @escaping (_ success: Bool,_ error: String, _ user: User?) -> Void) {
        
        let valid = helpingHand.validateLoginFields(email, password)
        var error = helpingHand.getLoginErrorMessage(email, password)
        if valid {
            actualRepo.login(email: email, password: password, { (success, user) in
                if success {
                    let user = user
                    error = ""
                    compeltion(true, error!, user) // can send complete user through
                }
            })
        } else {
            compeltion(false, error!, nil)
        }
    }
    
    public func signUp(firstName: String, lastName: String, email: String, password: String,
                       _ completion: @escaping(_ success: Bool, _ user: User?) -> Void) {
        actualRepo.signUp(firstName: firstName, lastName: lastName, email: email, password: password) { (user) in
            if let user = user {
                completion(true, user)
            }
        }
    }
    
    public func getUser() -> User {
        return self.user
    }
}
