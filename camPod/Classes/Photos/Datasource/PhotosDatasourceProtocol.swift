//
//  PhotosDatasourceProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation

public protocol PhotosDatasourceProtocol: class {
    func fetchPhotosFromStorage(albumID: String, imagePath: String,
                                _ completion: @escaping (_ photo: UIImage?,_ error: String?) -> Void)
    func uploadPhotoToStorage(albumID: String, imagePath: String, takenImage: UIImage,
                              _ completion: @escaping (_ didUpload: Bool, _ error: String?) -> Void)
    func addImagePathToUserAlbum(albumID: String, imagePaths: [String],
                             _ completion: @escaping (_ didAdd: Bool,_ error: String?) -> Void)
    func observe(albumID: String, _ completion: @escaping
                (_ addedImage: UIImage?, _ imagePath: String?, _ error: String?) -> Void)
    func deleteImagesReferencePaths(albumID: String, imagePaths: [String],
                                    _ compeltion: @escaping (_ error: String?) -> Void)
    func deleteImageFromStorage(albumID: String, imagePath: String,
                                _ compeltion: @escaping (_ error: String?) -> Void)
}
