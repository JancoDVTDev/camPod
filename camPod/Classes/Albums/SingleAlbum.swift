//
//  SingleAlbum.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/19.
//

import Foundation

public class SingleAlbum {

    public let albumID: String
    public let name: String
    public let dateCreated: String
    public let timeCreated: String
    public let createdBy: String
    public let thumbnail: UIImage
    public let imagePaths: [String]
    public let images: [UIImage]
    
    public init(albumID: String, name: String, dateCreated: String, timeCreated: String, createdBy: String, thumbnail: UIImage, imagePaths: [String], images: [UIImage]) {
        self.albumID = albumID
        self.name = name
        self.dateCreated = dateCreated
        self.timeCreated = timeCreated
        self.createdBy = createdBy
        self.thumbnail = thumbnail
        self.imagePaths = imagePaths
        self.images = images
    }
    
}
