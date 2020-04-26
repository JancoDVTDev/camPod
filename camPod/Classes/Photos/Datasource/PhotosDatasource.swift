//
//  PhotosDatasource.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation
import FirebaseAuth

public class PhotosDatasource: PhotosDatasourceProtocol {

    public func fetchPhotosFromStorage(albumID: String, imagePath: String,
                                _ completion: @escaping (UIImage?, String?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "\(albumID)/\(imagePath)")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image,nil)
                }
            }
        }
    }
    
    public func uploadPhotoToStorage(albumID: String, imagePath: String, takenImage: UIImage,
                                     _ completion: @escaping (Bool, String?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "\(albumID)/\(imagePath).jpg")
        guard let imageData = takenImage.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: uploadMetadata) { (metaData, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true,nil)
            }
        }
    }
    
    public func addImagePathToUserAlbum(albumID: String, imagePaths: [String],
                                    _ completion: @escaping (Bool, String?) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).child("ImagePaths").setValue(imagePaths)
        completion(true, nil)
    }
    
    public func observe(albumID: String,
                        _ completion: @escaping (_ addedImage: UIImage?,_ imagePath: String?, _ error: String?) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).child("ImagePaths").observe(.childAdded, with: { (snapshot) -> Void in
            let addedPhotoPath = snapshot.value as! String
            print(addedPhotoPath)
            self.fetchPhotosFromStorage(albumID: albumID, imagePath: addedPhotoPath) { (downloadedImage, error) in
                if let error = error {
                    completion(nil, nil, error)
                } else {
                    completion(downloadedImage, addedPhotoPath, nil)
                }
            }
        })
    }
}
