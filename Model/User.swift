//
//  User.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/27.
//

import Foundation

public class User {
    
    public var firstName: String
    public var lastName: String
    public var email: String
    public var password: String
    
    public var albums: [album]
    
    init(with email: String, and password: String) {
        self.email = email
        self.password = password
        
        //Sign user in with firebase
    }
}

public struct album {
    public var images: [UIImage]
}
