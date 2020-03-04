//
//  UserViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/02.
//

import Foundation

public class UserViewModels {
    
    func loginUser(email: String, password: String) {
        let existingUser = User(email: email, password: password)
    }
    
    func signUserIn(name: String, and surname: String, with email: String, and password: String) {
        let newUser = User(name: name, and: surname, with: email, and: password)
    }
}
