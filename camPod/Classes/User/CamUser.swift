//
//  CamUser.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public class CamUser {
    var firstName: String
    var lastName: String
    var email: String
    var albumIDs: [String]
    
    init(firstName: String, lastName: String, email: String, albumIDs: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.albumIDs = albumIDs
    }
}
