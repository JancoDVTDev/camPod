//
//  AlbumViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/28.
//

import Foundation

public class AlbumViewModel {
    
    var Lyngens: [UIImage] = [UIImage(named: "LynOne")!,UIImage(named: "LynTwo")!,UIImage(named: "LynThree")!,
                              UIImage(named: "LynFour")!,UIImage(named: "LynFive")!,UIImage(named: "LynSix")!,
                              UIImage(named: "LynSeven")!,UIImage(named: "LynEight")!,UIImage(named: "LynNine")!]

    var Cairngorms: [UIImage] = [UIImage(named: "CairOne")!,UIImage(named: "CairTwo")!,UIImage(named: "CairThree")!,
                                 UIImage(named: "CairFour")!,UIImage(named: "CairFive")!,UIImage(named: "CairSix")!,
                                 UIImage(named: "CairSeven")!,UIImage(named: "CairEight")!]

    var Mera: [UIImage] = [UIImage(named: "MeraOne")!,UIImage(named: "MeraTwo")!,UIImage(named: "MeraThree")!,
                           UIImage(named: "MeraFour")!,UIImage(named: "MeraFive")!,UIImage(named: "MeraSix")!,
                           UIImage(named: "MeraSeven")!,UIImage(named: "MeraEight")!,UIImage(named: "MeraNine")!,UIImage(named: "MeraTen")!]
    
    var Other: [UIImage] = [UIImage(named: "image-1")!,UIImage(named: "image-2")!,UIImage(named: "image-3")!,UIImage(named: "image-4")!]
    
    var allAlbums: [Album] = []
    
    public init() {
        let Lyn = Album(title: "Lyngens", thumbnail: self.Lyngens[0],images: self.Lyngens)
        let Cair = Album(title: "Cair", thumbnail: self.Cairngorms[0],images: self.Cairngorms)
        let Mera = Album(title: "Mera", thumbnail: self.Mera[0],images: self.Mera)
        let other = Album(title: "Other", thumbnail: self.Other[1], images: self.Other)
        
        allAlbums.append(Lyn)
        allAlbums.append(Cair)
        allAlbums.append(Mera)
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
