//
//  User.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/27.
//

import Foundation


public class User {

    public var email: String
    public var password: String
    
    public var albums: [Album]?
    
    init(with email: String, and password: String) {
        self.email = email
        self.password = password
        //Sign user in with firebase
    }
}

public class album {
    public var albumName: String
    public var images: [UIImage]?
    
    public init(name: String, images: [UIImage]?) {
        self.albumName = name
        self.images = images
    }
    
    public func appendImageToAlbum(image: UIImage) {
        images?.append(image)
    }
}
