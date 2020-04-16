//
//  User.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/18.
//

import Foundation
// MARK: DTO
public class User {
    public let firstName: String
    public let lastName: String
    public let email: String
    public var albumIDs: [String]

    public init(firstName: String, lastName: String, email: String, albumIDs: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.albumIDs = albumIDs
    }

    public func appendAlbumIDs(albumID: String) {
        albumIDs.append(albumID)
    }
}
