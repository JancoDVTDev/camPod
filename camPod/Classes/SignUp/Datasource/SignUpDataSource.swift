//
//  SignUpDataSource.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation
import FirebaseAuth

public class SignUpDataSource: SignUpDataSourceProtocol {

    public init() { }

    public func signUp(firstName: String, lastName: String, email: String, password: String, _ completion: @escaping (String?, Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(error.localizedDescription, false)
            } else {
                let databaseRef = Database.database().reference()
                databaseRef.child("Users").child(Auth.auth().currentUser!.uid).setValue(["firstName": firstName,
                                                                                         "lastName": lastName,
                                                                                         "Albums": [""]])
                completion(nil, true)
            }
        }
    }
}
