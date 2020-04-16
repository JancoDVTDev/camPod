//
//  PhotosViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation

public class PhotosViewModel {
    public weak var view: PhotoViewProtocol?
    public var repo: PhotosDatasourceProtocol?
    
    func loadPhotos(albumID: String, imagePaths: [String]) {
        var count = 0
        var tempImages = [UIImage]()
        if imagePaths.contains("") {
            self.view?.didFinishLoading()
        } else {
            for imagePath in imagePaths {
                repo?.fetchPhotosFromStorage(albumID: albumID, imagePath: imagePath, { (image, error) in
                    if let error = error {
                        self.view?.displayError(error: error)
                    } else {
                        if let image = image {
                            count += 1
                            tempImages.append(image)
                            if count == imagePaths.count {
                                self.view?.didFinishLoading()
                                self.view?.updateCollectionViewSource(images: tempImages)
                                self.view?.updateCollectionView()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func savePhoto(albumID: String, imagePaths: [String], takenPhoto: UIImage, images: [UIImage]) {
        let takenImagePath = UUID().uuidString
        let formattedImagePath = takenImagePath + ".jpg"
        
        var reducedImage: UIImage?
        if let imageData = takenPhoto.jpeg(.lowest) {
            reducedImage = UIImage(data: imageData)!
        }
        
        var updatedImagesPath: [String]
        if imagePaths.contains("") {
            updatedImagesPath = [formattedImagePath]
        } else {
            updatedImagesPath = imagePaths
            updatedImagesPath.append(formattedImagePath)
        }

        var updatedCollectionViewSource = images
        updatedCollectionViewSource.append(reducedImage!)

        self.view?.updateImagePaths(imagePaths: updatedImagesPath)
        self.view?.updateCollectionViewSource(images: updatedCollectionViewSource)
        self.view?.updateCollectionView()

        repo?.uploadPhotoToStorage(albumID: albumID, imagePath: takenImagePath, takenImage: reducedImage!, { (_, error) in
            if let error = error {
                self.view?.displayError(error: error)
            } else {
                self.repo?.addImagePathToUserAlbum(albumID: albumID, imagePaths: updatedImagesPath,
                                                   { (_, error) -> Void in
                    if let error = error {
                        self.view?.displayError(error: error)
                    } else {
                        self.view?.didFinishLoading()
                    }
                })
            }
        })
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1.0
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
