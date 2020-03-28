//
//  AlbumModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/17.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

public protocol AlbumModelProtocol: class {
    func downloadAlbumFromFirebaseStorage(albumID: String, _ completion: @escaping (_ album: SingleAlbum) -> Void)
    func addNewAlbum(user: User, albumID: String, albumName: String,
    _ completion: @escaping (_ success: Bool, _ album: SingleAlbum) -> ())
}

public class AlbumModel: AlbumModelProtocol {

    var user: User!

    public init() {
        
    }

    public func addNewAlbum(user: User, albumID: String, albumName: String,
                            _ completion: @escaping (_ success: Bool, _ album: SingleAlbum) -> ()) {

        // Metadata
        let date = Date()
        let calendar = Calendar.current
        let defaultImagePath = UUID.init().uuidString
        let currentDate = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
        let currentTime = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        let album = SingleAlbum(albumID: albumID, name: albumName, dateCreated: currentDate, timeCreated: currentTime, createdBy: Auth.auth().currentUser!.uid, thumbnail: UIImage(named: "placeholder")!, imagePaths: [defaultImagePath])
        
        let ref = Database.database().reference()
        //Step 1 - album needs to be added to AllAlbumsExisting in Firebase and validated for existence
        ref.child("AllAlbumsExisting").child(album.albumID).setValue(["Name" : album.name,
                                                                      "Created by": Auth.auth().currentUser!.uid,
                                                                      "Date": album.dateCreated,
                                                                      "Time": album.timeCreated,
                                                                      "ImagePaths": album.imagePaths])
        
        //Step 2 - add new albumID to the list of the users albumIDs and saved to database
        if user.albumIDs.contains("") {
            user.albumIDs.removeAll()
        }
        user.albumIDs.append(albumID)
        ref.child("Users").child(Auth.auth().currentUser!.uid).child("Albums").setValue(user.albumIDs) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }

        //Step 3 - albumID needs to be added as a storage url in Firebase Storage
        let uploadRef = Storage.storage().reference(withPath: "\(albumID)/\(defaultImagePath)/\(defaultImagePath)")
        guard let imageData = UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, err) in
            if let err = err {
                print("Error creating reference to storage \(err.localizedDescription)")
            } else {
                completion(true, album)
            }
        }
    }

    public func downloadAlbumFromFirebaseStorage(albumID: String,
                                                 _ completion: @escaping (_ album: SingleAlbum) -> Void) {
        // Download all images that belong to albumID, on completion send back a SingleAlbum
        // If there are no images make the thumbnail default image
        getAlbumMetaDataFromFirebase(albumID: albumID) { (albumName, date, time, createdBy, imagePaths) in
            let imageCount = imagePaths.count
            var thumbnail = UIImage()
            var albumImages = [UIImage]()
            for pathIndex in 0..<imageCount {
                self.getImageFromFirebaseStorage(albumID: albumID, imagePath: imagePaths[pathIndex]) { (image) in
                    albumImages.append(image)
                    if pathIndex == 0 {
                        thumbnail = image
                    }
                    if pathIndex == imageCount - 1 {
                        completion(SingleAlbum(albumID: albumID, name: albumName, dateCreated: date, timeCreated: time, createdBy: createdBy, thumbnail: thumbnail, imagePaths: imagePaths))
                    }
                }
            }
        }
    }

    func getImageFromFirebaseStorage(albumID: String, imagePath: String,
                                     _ completion: @escaping (_ image: UIImage) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "\(albumID)/\(imagePath)/\(imagePath)")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("No image found")
                }
            } else {
                print("No data found")
            }
        }
    }

    func getAlbumMetaDataFromFirebase(albumID: String, _ completion: @escaping (_ albumName: String,_ dateCreated: String,
        _ timeCreated: String,_ createdBy: String,_ imagePaths: [String]) -> Void) {
        let ref = Database.database().reference()
        ref.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let albumName = value?["Name"] as? String ?? ""
            let dateCreated = value?["Date"] as? String ?? ""
            let timeCreated = value?["Time"] as? String ?? ""
            let createdBy = value?["Created by"] as? String ?? ""
            let imagePaths = value?["ImagePaths"] as? [String] ?? [""]
            completion(albumName, dateCreated, timeCreated, createdBy, imagePaths)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    // MARK: HELPER FUNCTIONS
    func validateAlbumID(albumID: String) -> Bool {
        let ref = Database.database().reference()
        ref.child("AllExistingAlbums").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! String
            if value == albumID {

            }
        }
        return true
    }
}
