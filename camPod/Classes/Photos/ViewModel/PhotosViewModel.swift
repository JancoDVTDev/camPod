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
    public var coreDataRepo = CoreDataRepo()
    public var cacheHelper: CacheHelper?

    func loadSavedImages(imagePaths: [String], _ completion: @escaping (_ cachedPhotoModels: [PhotoModel],
        _ imagePathsToUpdate: [String]) -> Void) {

        var savedPhotoModels = [PhotoModel]()
        var imagePathsToUpdate = [String]()
        self.coreDataRepo.fetchSavedImagesInCoreData(imagePaths: imagePaths)
        {(photoModels, newPhotoPaths, error) in
            if let error = error {
                self.view?.displayError(error: error)
                self.view?.didFinishLoading()
            } else {
                savedPhotoModels = photoModels
                imagePathsToUpdate = newPhotoPaths
                completion(savedPhotoModels, imagePathsToUpdate)
            }
        }
    }

    func loadPhotos(albumID: String, imagePaths: [String]) {
        var toBeUpdatedImagePaths = [String]()
        var onDiskPhotoModels = [PhotoModel]()
        var count = 0

        loadSavedImages(imagePaths: imagePaths) { (savedPhotoModels, newPhotoPaths) in
            onDiskPhotoModels = savedPhotoModels
            toBeUpdatedImagePaths = newPhotoPaths

            self.view?.updatePhotoModels(photoModels: onDiskPhotoModels)
            self.view?.updateCollectionView()
            self.view?.didFinishLoading()

            if !(newPhotoPaths.isEmpty) {
                //var newPhotoModels = [PhotoModel]()
                for imagePath in toBeUpdatedImagePaths {
                    self.repo?.fetchPhotosFromStorage(albumID: albumID, imagePath: imagePath,
                                                      {(image, error) in
                        self.view?.startDownloading()
                        count += 1
                        if let error = error {
                            self.view?.displayError(error: error)
                            self.view?.didFinishLoading()
                        } else {
                            let newPhoto = PhotoModel(name: imagePath, image: image!)
                            onDiskPhotoModels.append(newPhoto)
                            self.coreDataRepo.saveImageToCoreData(photoModel: newPhoto)
                            if count == toBeUpdatedImagePaths.count {
                                self.view?.updatePhotoModels(photoModels: onDiskPhotoModels)
                                self.view?.updateCollectionView()
                                self.view?.didFinishLoading()
                                self.view?.startDownloading()
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
        coreDataRepo.saveImageToCoreData(photoModel: newPhoto)

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

    func observeTakenPhotos(albumID: String, imagePaths: [String], photoModels: [PhotoModel]) {
        var updatedImagePaths = imagePaths
        var updatedPhotoModels = photoModels
        repo?.observe(albumID: albumID, { (downloadedImage, imagePath, error) in
            if let error = error {
                self.view?.displayError(error: "Observer: \(error)")
            } else {
                guard let imagePath = imagePath else {return}
                guard let downloadedImage = downloadedImage else {return}
                if !(imagePaths.contains(imagePath)) {
                    updatedImagePaths.append(imagePath)
                    updatedPhotoModels.append(PhotoModel(name: imagePath, image: downloadedImage))
                    self.view?.updateImagePaths(imagePaths: updatedImagePaths)
                    self.view?.updatePhotoModels(photoModels: updatedPhotoModels)
                    self.view?.updateCollectionView()
                    self.view?.didFinishLoading()
                }
            }
        })
    }

    func deleteImages(albumID: String, imagePaths: [String], deleteImagePaths: [String]) {
        coreDataRepo.deleteImagesFromCoreData(imagePaths: deleteImagePaths)
        repo?.deleteImagesReferencePaths(albumID: albumID, imagePaths: imagePaths, { (error) in
            if let error = error {
                self.view?.displayError(error: error)
            } else {
                for imagePath in deleteImagePaths {
                    self.repo?.deleteImageFromStorage(albumID: albumID, imagePath: imagePath, { (error) in
                        if let error = error {
                            self.view?.displayError(error: error)
                        }
                    })
                }
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
