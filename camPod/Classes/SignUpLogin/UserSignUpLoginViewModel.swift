//
//  UserSignUpLoginViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation

public class UserSignUpLoginViewModel {
    
    public init() {
        
    }
    public func signUp(name: String, and surname: String, with email: String, and password: String) {
        let currentUser = UserModel(name: name, and: surname, with: email, and: password)
    }
    
    public func login() {
        
    }
}
