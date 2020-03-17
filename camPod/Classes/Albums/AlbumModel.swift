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
    func downloadAlbumFromFirebaseStorage(albumID: String,
    _ completion: @escaping (_ album: SingleAlbum) -> Void)
}

public class AlbumModel: AlbumModelProtocol {
    
    var user: User!
    
    init(user: User?) {
        self.user = user
    }
    
    public func addNewAlbum(albumID: String, albumName: String,  _ completion: @escaping (_ success: Bool, _ album: SingleAlbum) -> ()) {
        
        // Metadata
        let date = Date()
        let calendar = Calendar.current
        
        let currentDate = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
        let currentTime = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        let album = SingleAlbum(albumID: albumID, name: albumName, dateCreated: currentDate, timeCreated: currentTime, createdBy: Auth.auth().currentUser!.uid, thumbnail: UIImage(named: "placeholder")!, images: [])
        
        let ref = Database.database().reference()
        //Step 1 - album needs to be added to AllAlbumsExisting in Firebase and validated for existence
        ref.child("AllAlbumsExisting").child(album.albumID).setValue(["Name" : album.name, "Created by": Auth.auth().currentUser!.uid, "Date": album.dateCreated, "Time": album.timeCreated])
        
        //Step 2 - add new albumID to the list of the users albumIDs and saved to database
        user.appendAlbumIDs(albumID: albumID)
        ref.child("Users").child(Auth.auth().currentUser!.uid).setValue(["Albums": user.albumIDs]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
        
        //Step 3 - albumID needs to be added as a storage url in Firebase Storage
        Storage.storage().reference(withPath: "\(albumID)/")
        completion(true, album)
    }
    
    public func downloadAlbumFromFirebaseStorage(albumID: String,
                                                 _ completion: @escaping (_ album: SingleAlbum) -> Void) {
        // Download all images that belong to albumID, on completion send back a SingleAlbum
        // If there are no images make the thumbnail default image
    }
    
    // MARK: HELPER FUNCTIONS
    func validateAlbumID(albumID: String) -> Bool {
        var flag = false
        let ref = Database.database().reference()
        ref.child("AllExistingAlbums").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! String
            if value == albumID {
                
            }
        }
        return true
    }
}

public struct SingleAlbum {
    
    public let albumID: String
    public let name: String
    public let dateCreated: String
    public let timeCreated: String
    public let createdBy: String
    public let thumbnail: UIImage
    public let images: [UIImage]
}
