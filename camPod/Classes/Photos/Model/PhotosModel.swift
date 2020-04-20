//
//  PhotosModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation

public class PhotoModel {
    var name: String
    var image: UIImage

    public init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}
