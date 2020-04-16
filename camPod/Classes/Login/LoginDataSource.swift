//
//  LoginDataSource.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation
import FirebaseAuth

public class LoginDataSource: LoginDataSourceProtocol {
    
    public init() { }
    
    public func login(email: String, password: String, _ completion: @escaping (String?, Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(error.localizedDescription, false)
            } else {
                completion(nil, true)
            }
        }
    }
}
