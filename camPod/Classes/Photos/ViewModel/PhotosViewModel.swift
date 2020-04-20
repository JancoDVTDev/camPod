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
    public var cacheHelper: CacheHelper?

    func loadCachedImages(imagePaths: [String],
                                  _ completion: @escaping (_ imagePathsToUpdate: [String],
        _ cachedPhotoModels: [PhotoModel]) -> Void) {
        var cachedPhotoModels = [PhotoModel]()
        var imagePathsToUpdate = [String]()
        var count = 0
        for imagePath in imagePaths {
            cacheHelper?.loadImageFromDisk(fileName: imagePath, { (imagePathToUpdate, cachedImage) in
                count += 1
                if let imagePathToUpdate = imagePathToUpdate {
                    imagePathsToUpdate.append(imagePathToUpdate)
                } else {
                    cachedPhotoModels.append(PhotoModel(name: imagePath, image: cachedImage!))
                }
                if count == imagePaths.count {
                    completion(imagePathsToUpdate, cachedPhotoModels)
                }
            })
        }
    }

    func saveImagesToCache(photos: [PhotoModel]) {
        for index in 0..<photos.count {
            cacheHelper?.saveImage(imageName: photos[index].name, image: photos[index].image)
        }
    }

    func loadPhotos(albumID: String, imagePaths: [String]) {
        var toBeUpdatedImagePaths = [String]()
        var onTheDiskPhotoModels = [PhotoModel]()

        loadCachedImages(imagePaths: imagePaths) { (imagePathsInCloud, onDiskPhotoModels) in
            toBeUpdatedImagePaths = imagePathsInCloud
            onTheDiskPhotoModels = onDiskPhotoModels
            self.view?.didFinishLoading()
            self.view?.updatePhotoModels(photoModels: onDiskPhotoModels)
            self.view?.updateCollectionView()
            var count = 0
            var tempImages = [UIImage]()
            var photoModels = [PhotoModel]()
            if toBeUpdatedImagePaths.contains("") {
                self.view?.didFinishLoading()
            } else {
                for imagePath in toBeUpdatedImagePaths {
                    self.repo?.fetchPhotosFromStorage(albumID: albumID, imagePath: imagePath, { (image, error) in
                        if let error = error {
                            self.view?.displayError(error: error)
                        } else {
                            if let image = image {
                                count += 1
                                tempImages.append(image)
                                photoModels.append(PhotoModel(name: imagePath, image: image))
                                if count == toBeUpdatedImagePaths.count {
                                    self.saveImagesToCache(photos: photoModels)
                                    photoModels.append(contentsOf: onTheDiskPhotoModels)
                                    self.view?.didFinishLoading()
                                    self.view?.updatePhotoModels(photoModels: photoModels)
                                    self.view?.updateCollectionViewSource(images: tempImages)
                                    self.view?.updateCollectionView()
                                }
                            }
                        }
                    })
                }
            }
        }
    }

    func savePhoto(albumID: String, imagePaths: [String], takenPhoto: UIImage, photoModels: [PhotoModel]) {
        let takenImagePath = UUID().uuidString
        let formattedImagePath = takenImagePath + ".jpg"

        var reducedImage: UIImage?
        if let imageData = takenPhoto.jpeg(.lowest) {
            reducedImage = UIImage(data: imageData)!
        }

        let newPhoto = PhotoModel(name: formattedImagePath, image: reducedImage!)
        saveImagesToCache(photos: [newPhoto])

        var updatedImagesPath: [String]
        if imagePaths.contains("") {
            updatedImagesPath = [formattedImagePath]
        } else {
            updatedImagesPath = imagePaths
            updatedImagesPath.append(formattedImagePath)
        }

        var updatedPhotoModels = photoModels
        updatedPhotoModels.append(newPhoto)

        self.view?.updateImagePaths(imagePaths: updatedImagesPath)
        self.view?.updatePhotoModels(photoModels: updatedPhotoModels)
        self.view?.updateCollectionView()

        repo?.uploadPhotoToStorage(albumID: albumID, imagePath: takenImagePath, takenImage: reducedImage!, { (_, error) in
            if let error = error {
                self.view?.displayError(error: error)
            } else {
                self.repo?.addImagePathToUserAlbum(albumID: albumID,
                                                   imagePaths: updatedImagesPath,
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

    func compareDiskImagesToCloudImages(cloudImagePaths: [String], onDiskImagePaths: [String]) -> [String]? {
        var toBeUpdatedImagePaths = [String]()

        if cloudImagePaths.count == onDiskImagePaths.count {
            return toBeUpdatedImagePaths
        } else {
            toBeUpdatedImagePaths = cloudImagePaths.difference(from: onDiskImagePaths)
        }

        return toBeUpdatedImagePaths
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

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
