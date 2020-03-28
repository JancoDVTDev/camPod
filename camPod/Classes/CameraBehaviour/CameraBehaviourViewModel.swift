//
//  CameraBehaviourViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

public class CameraBehaviourViewModel {
    public init() {
        
    }
    
    let currentUser = UserModel()
    // Note to self: When an albumis created write to the user the uniqueAlbumID and the albumName
    public func saveTakenImage(image: UIImage, albumID: String, imagePaths: [String]) {
        let randomPicName = UUID.init().uuidString
        var newImageRefPaths = imagePaths
        let uploadRef = Storage.storage().reference(withPath: "\(albumID)/\(randomPicName)/\(randomPicName)")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no error \(error.localizedDescription)")
            } else {
                print("put is complete and I got this back: \(String(describing: downloadMetadata))")
                let databaseRef = Database.database().reference()
                newImageRefPaths.append(randomPicName)
                databaseRef.child("AllAlbumsExisting").child(albumID).child("ImagePaths").setValue(newImageRefPaths)
            }
        }
    }
}
