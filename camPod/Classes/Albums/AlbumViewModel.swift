//
//  AlbumViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/02/28.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

public class AlbumViewModel {

    var albumModelRepo: AlbumModelProtocol?
    var actualAlbumModelRepo = AlbumModel()
//    var user: User?
    let userRepo = UserModel()
    var allAlbums: [Album] = []
    var albums: [SingleAlbum] = []

    public init() {

    }

    public init(user: User) {
//        self.user = user
        self.albumModelRepo = AlbumModel()
    }

    public func getAllAlbums(albumIDs: [String], _ completion: @escaping (_ albums: [SingleAlbum]) -> Void) {
        populateAlbums(albumIDs: albumIDs) { (success) in
            if success {
                completion(self.albums)
            }
        }
    }

    func populateAlbums(albumIDs: [String], _ completion: @escaping (_ success: Bool) -> Void) {
        for albumID in albumIDs {
            actualAlbumModelRepo.downloadAlbumFromFirebaseStorage(albumID: albumID, { (singleAlbum) in
                self.albums.append(singleAlbum)
            })
        }
    }

    public func getAlbumNew(albumID: String, _ completion: @escaping (_ album: SingleAlbum) -> Void) {
        let databaseRef = Database.database().reference()
        var thumbnail = UIImage()
        databaseRef.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let createdBy = value["Created By"] as? String ?? ""
            let date = value["Date"] as? String ?? ""
            let imagePaths = value["ImagePaths"] as? [String] ?? ["3B3A44E7-F387-4318-BD16-DA9985394C54"]
            let name = value["Name"] as? String ?? ""
            let time = value["Time"] as? String ?? ""
            let storageRef = Storage.storage().reference(withPath: "\(albumID)/\(imagePaths[0])/\(imagePaths[0])")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, err) in
                if let err = err {
                    print("Error with image \(err.localizedDescription)")
                }
                if let data = data {
                    thumbnail = (UIImage(data: data)!)
                    print("Appending image data")
                    print("Album: \(albumID) completed")
                    let currAlbum = SingleAlbum(albumID: albumID, name: name, dateCreated: date, timeCreated: time, createdBy: createdBy, thumbnail: thumbnail, imagePaths: imagePaths)
                    completion(currAlbum)
                }
            }
        }
    }

    public func getUserData(_ completion: @escaping (_ success: Bool, _ isNewUser: Bool, _ user: User) -> Void) {
        var albumNames = [String]()
        let ref: DatabaseReference = Database.database().reference()
        ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let firstName = value["firstName"] as? String ?? ""
            let lastName = value["lastName"] as? String ?? ""
            let albumIDs = value["Albums"] as? [String] ?? [""]
            
            if albumIDs.contains("") && albumIDs.count == 1{
                print("New User has now albums yet")
                let user = User(firstName: firstName, lastName: lastName, email: (Auth.auth().currentUser?.email)!, albumIDs: albumIDs)
                completion(true, true, user)
            } else {
                for albumID in albumIDs {
                    self.getAlbumNameFromFirebase(albumID: albumID) { (albumName) in
                        albumNames.append(albumName)
                        if albumNames.count == albumIDs.count {
                            let user = User(firstName: firstName, lastName: lastName, email: (Auth.auth().currentUser?.email)!, albumIDs: albumIDs)
                            completion(true, false, user)
                        }
                    }
                }
            }
        }
    }
    
    public func deleteAlbum(albumIDs: [String], selectedAlbumIndex: Int, _ completion: (_ albumIDs: [String]) -> Void) {
        var newAlbumIDs = albumIDs
        newAlbumIDs.remove(at: selectedAlbumIndex)
        updateUserAlbumIDs(newAlbumIDs: newAlbumIDs)
        completion(newAlbumIDs)
    }
    
    public func updateUserAlbumIDs(newAlbumIDs: [String]) {
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").child(Auth.auth().currentUser!.uid)
            .child("Albums").setValue(newAlbumIDs)
    }

    public func addNewAlbum(albumName: String, _ completion: @escaping (_ album: SingleAlbum) -> Void) {
        let helpingHand: ObjcHelper = ObjcHelper()
        let newAlbumIDFromObjC = helpingHand.generateUniqueID()
        print(newAlbumIDFromObjC as Any)
        let newAlbumID = generateUniqueAlbumID()
        getUserData { (success, isNewUser, user) in
            self.actualAlbumModelRepo.addNewAlbum(user: user, albumID: newAlbumID, albumName: albumName, { (success, album) in
                if success {
                    completion(album)
                }
            })
        }
    }
    
    public func getExistingAlbumFromFirebase(albumID: String,_ completion: @escaping (_ album: SingleAlbum) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let createdBy = value["Created By"] as? String ?? ""
            let date = value["Date"] as? String ?? ""
            let imagePaths = value["ImagePaths"] as? [String] ?? [""]
            let name = value["Name"] as? String ?? ""
            let time = value["Time"] as? String ?? ""
            // get the thubnail
            let thumbnailPath = "\(albumID)/\(imagePaths[0])/\(imagePaths[0])"
            let storageRef = Storage.storage().reference(withPath: thumbnailPath)
            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if error != nil {
                    print("Error adding From getExistingAlbumFromFirebase WITH \(error!.localizedDescription)")
                }
                if let data = data {
                    let thumbnailImage = UIImage(data: data)
                    completion(SingleAlbum(albumID: albumID, name: name, dateCreated: date, timeCreated: time, createdBy: createdBy, thumbnail: thumbnailImage!, imagePaths: imagePaths))
                }
            }
        }
    }

    func getAlbumNameFromFirebase(albumID: String, _ completion: @escaping (_ albumName: String) -> Void) {
        let databaseRef: DatabaseReference = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
          let albumName = value?["Name"] as? String ?? ""
          completion(albumName)
          }) { (error) in
            print(error.localizedDescription)
        }
    }

    func generateUniqueAlbumID() -> String {
        let uniqueString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321abcdefghijklmnopqrstuvwxyz"
        let uniqueChars = Array(uniqueString)
        var compiledUniqueString: String = ""

//        repeat {
            for _ in 0..<25 {
                let randomNumber = Int.random(in: 0..<uniqueChars.count)
                compiledUniqueString += String(uniqueChars[randomNumber])
            }
//        } while (isIDUnique(generatedID: compiledUniqueString) == false)
        return compiledUniqueString
    }

    public func getAlbumsCount() -> Int {
        return albums.count
    }

    //Old Functions
}
