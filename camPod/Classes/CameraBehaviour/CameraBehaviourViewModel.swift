//
//  CameraBehaviourViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

public class CameraBehaviourViewModel {
    public init() {
        
    }
    
    let currentUser = UserModel()
    // Note to self: When an albumis created write to the user the uniqueAlbumID and the albumName
    public func saveTakenImage(image: UIImage, albumPath: String, albumName: String) {
        let userID = Auth.auth().currentUser?.uid
        let randomPicName = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "\(currentUser.name)/\(currentUser.surname)/\(randomPicName).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no error \(error.localizedDescription)")
            } else {
                print("put is complete and I got this back: \(String(describing: downloadMetadata))")
            }
        }
    }
}
