//
//  AlbumViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/28.
//

import Foundation

public class AlbumViewModel {
    
    var lyngens: [UIImage] = [UIImage(named: "LynOne")!,UIImage(named: "LynTwo")!,UIImage(named: "LynThree")!,
                              UIImage(named: "LynFour")!,UIImage(named: "LynFive")!,UIImage(named: "LynSix")!,
                              UIImage(named: "LynSeven")!,UIImage(named: "LynEight")!,UIImage(named: "LynNine")!]

    var cairngorms: [UIImage] = [UIImage(named: "CairOne")!,UIImage(named: "CairTwo")!,UIImage(named: "CairThree")!,
                                 UIImage(named: "CairFour")!,UIImage(named: "CairFive")!,UIImage(named: "CairSix")!,
                                 UIImage(named: "CairSeven")!,UIImage(named: "CairEight")!]

    var mera: [UIImage] = [UIImage(named: "MeraOne")!,UIImage(named: "MeraTwo")!,UIImage(named: "MeraThree")!,
                           UIImage(named: "MeraFour")!,UIImage(named: "MeraFive")!,UIImage(named: "MeraSix")!,
                           UIImage(named: "MeraSeven")!,UIImage(named: "MeraEight")!,UIImage(named: "MeraNine")!,UIImage(named: "MeraTen")!]
    
    var other: [UIImage] = [UIImage(named: "image-1")!,UIImage(named: "image-2")!,UIImage(named: "image-3")!,UIImage(named: "image-4")!]
    
    var allAlbums: [Album] = []
    
    public init() {
        let lyn = Album(title: "Lyngens", thumbnail: self.lyngens[0],images: self.lyngens)
        let cair = Album(title: "Cair", thumbnail: self.cairngorms[0],images: self.cairngorms)
        let mera = Album(title: "Mera", thumbnail: self.mera[0],images: self.mera)
        let other = Album(title: "Other", thumbnail: self.other[1], images: self.other)
        
        allAlbums.append(lyn)
        allAlbums.append(cair)
        allAlbums.append(mera)
        allAlbums.append(other)
    }
    
    public func getCount() -> Int {
        return allAlbums.count
    }
    
    public func getThumbnail(index: Int) -> UIImage {
        return allAlbums[index].getThumbnail()
    }
    
    public func getSingleImage(selectedAlbum: Int, index: Int) -> UIImage {
        return allAlbums[selectedAlbum].getSingleImage(index: index)
    }
    
    public func getAlbumSize(index: Int) -> Int {
        return allAlbums[index].getAlbumSize()
    }
    
    public func appendToAlbum(albumIndex: Int, image: UIImage) {
        allAlbums[albumIndex].appendImage(image: image)
    }
    
    public func getAlbum(index: Int) -> Album {
        return allAlbums[index]
    }
}
