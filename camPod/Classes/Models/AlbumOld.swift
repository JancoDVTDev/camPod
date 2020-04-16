//
//  Album.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/28.
//

import Foundation

public class AlbumOld {
    //Read from Firebase the title of the Album, its thumnail image and the images array
    var title: String
    var thumbnail: UIImage
    var images: [UIImage]
    init(title: String,thumbnail: UIImage, images: [UIImage]) {
        self.title = title
        self.thumbnail = thumbnail
        self.images = images
    }

    func getThumbnail() -> UIImage {
        return thumbnail
    }

    func getSingleImage(index: Int) -> UIImage {
        return images[index]
    }

    func getAlbumSize() -> Int {
        return images.count
    }

    func appendImage(image: UIImage) {
        images.append(image)
    }
}
