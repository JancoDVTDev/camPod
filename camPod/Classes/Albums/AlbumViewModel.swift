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
    
    var lyngens: [UIImage] = [UIImage(named: "LynOne")!,UIImage(named: "LynTwo")!,UIImage(named: "LynThree")!,
                              UIImage(named: "LynFour")!,UIImage(named: "LynFive")!,UIImage(named: "LynSix")!,
                              UIImage(named: "LynSeven")!,UIImage(named: "LynEight")!,UIImage(named: "LynNine")!]

    var cairngorms: [UIImage] = [UIImage(named: "CairOne")!,UIImage(named: "CairTwo")!,UIImage(named: "CairThree")!,
                                 UIImage(named: "CairFour")!,UIImage(named: "CairFive")!,UIImage(named: "CairSix")!,
                                 UIImage(named: "CairSeven")!,UIImage(named: "CairEight")!]

    var mera: [UIImage] = [UIImage(named: "MeraOne")!,UIImage(named: "MeraTwo")!,UIImage(named: "MeraThree")!,
                           UIImage(named: "MeraFour")!,UIImage(named: "MeraFive")!,UIImage(named: "MeraSix")!,
                           UIImage(named: "MeraSeven")!,UIImage(named: "MeraEight")!,UIImage(named: "MeraNine")!,UIImage(named: "MeraTen")!]

    var other: [UIImage] = [UIImage(named: "image-1")!,UIImage(named: "image-2")!,UIImage(named: "image-3")!,UIImage(named: "image-4")!]
    
    var allAlbums: [Album] = []
    var albums: [SingleAlbum] = []
    
    public init() {
        let lyn = Album(title: "Lyngens", thumbnail: self.lyngens[0],images: self.lyngens)
        let cair = Album(title: "Cair", thumbnail: self.cairngorms[0],images: self.cairngorms)
        let mera = Album(title: "Mera", thumbnail: self.mera[0],images: self.mera)
        let other = Album(title: "Other", thumbnail: self.other[1], images: self.other)

        allAlbums.append(lyn)
        allAlbums.append(cair)
        allAlbums.append(mera)
        allAlbums.append(other)
    }
    
    public init(user: User) {
//        self.user = user
        self.albumModelRepo = AlbumModel()
        let lyn = Album(title: "Lyngens", thumbnail: self.lyngens[0],images: self.lyngens)
        let cair = Album(title: "Cair", thumbnail: self.cairngorms[0],images: self.cairngorms)
        let mera = Album(title: "Mera", thumbnail: self.mera[0],images: self.mera)
        let other = Album(title: "Other", thumbnail: self.other[1], images: self.other)

        allAlbums.append(lyn)
        allAlbums.append(cair)
        allAlbums.append(mera)
        allAlbums.append(other)
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
    
    public func getAlbumNew(albumID: String, _ completion: @escaping (_ album: [UIImage]) -> Void) {
        let databaseRef = Database.database().reference()
        var currentAlbum = [UIImage]()
        databaseRef.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let imagePaths = value["ImagePaths"] as? [String] ?? [""]
            for imagePath in imagePaths {
                let storageRef = Storage.storage().reference(withPath: "\(albumID)/\(imagePath)/\(imagePath)")
                storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, err) in
                    if let err = err {
                        print("Error with image \(err.localizedDescription)")
                    }
                    if let data = data {
                        currentAlbum.append(UIImage(data: data)!)
                        print("Appending image data")
                        if imagePath == imagePaths[imagePaths.endIndex - 1] {
                            print("Album: \(albumID) completed")
                            completion(currentAlbum)
                        }
                    }
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
    
    public func addNewAlbum(albumName: String, _ completion: @escaping (_ album: SingleAlbum) -> Void) {
        let newAlbumID = generateUniqueAlbumID()
        getUserData { (success, isNewUser, user) in
            self.actualAlbumModelRepo.addNewAlbum(user: user, albumID: newAlbumID, albumName: albumName, { (success, album) in
                if success {
                    completion(album)
                }
            })
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
    
    public func getCount() -> Int {
        return allAlbums.count
    }
    
    public func getThumbnail(index: Int) -> UIImage {
        return allAlbums[index].getThumbnail()
    }
    
    public func getSingleImage(selectedAlbum: Int, index: Int) -> UIImage {
        return allAlbums[selectedAlbum].getSingleImage(index: index)
    }
    
    public func getAlbumSize(index: Int) -> Int {
        return allAlbums[index].getAlbumSize()
    }
    
    public func appendToAlbum(albumIndex: Int, image: UIImage) {
        allAlbums[albumIndex].appendImage(image: image)
    }
    
    public func getAlbum(index: Int) -> Album {
        return allAlbums[index]
    }
}
