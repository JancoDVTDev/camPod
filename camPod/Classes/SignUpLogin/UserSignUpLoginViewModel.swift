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
    
    public init(repo: UserModelProtocol) {
        self.repo = repo
    }
    
    public func login(with email: String, and password: String,
                      _ compeltion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        actualRepo.login(email: email, password: password, { (success, user) in
            if success {
                let User = user
                compeltion(true, User) // can send complete user through
            }
        })
    }
    
    public func signUp(firstName: String, lastName: String, email: String, password: String,
                       _ completion: @escaping(_ success: Bool, _ user: User?) -> Void) {
        actualRepo.signUp(firstName: firstName, lastName: lastName, email: email, password: password) { (user) in
            if let user = user {
                completion(true, user)
            }
        }
    }
}
