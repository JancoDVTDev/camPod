//
//  AlbumDataSource.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation
import FirebaseAuth

public class AlbumDataSource: AlbumDataSourceProtocol {

    public init() { }

    public func fetchUserAlbumIDs(_ completion: @escaping ([String]?, String?) -> Void) {
        let databaseRef = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        databaseRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let albumIDs = value?["Albums"] as? [String] ?? [""]
            completion(albumIDs, nil)
        }) { (error) in
            completion(nil, error.localizedDescription)
        }
    }

    public func fetchUserSingleAlbum(albumID: String,
                                      completion: @escaping (SingleAlbum?, String?) -> Void) {
        var tempSingleAlbum: SingleAlbum?
        let databaseRef = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let createdBy = value?["Created By"] as? String ?? ""
            let date = value?["Date"] as? String ?? ""
            let imagePaths = value?["ImagePaths"] as? [String] ?? [""]
            let name = value?["Name"] as? String ?? "&%$"
            let time = value?["Time"] as? String ?? ""
            
            if imagePaths.contains("") {
                let thumbnail = UIImage(named: "placeholder")
                tempSingleAlbum = SingleAlbum(albumID: albumID, name: name,
                                              dateCreated: date, timeCreated: time,
                                              createdBy: createdBy, thumbnail: thumbnail!,
                                              imagePaths: imagePaths)
                completion(tempSingleAlbum,nil)
            } else {
                let storageRef = Storage.storage().reference(withPath: "\(albumID)/\(imagePaths[0])")
                storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        completion(nil,error.localizedDescription)
                        print(error.localizedDescription)
                    } else {
                        if let data = data {
                            let thumbnail = UIImage(data: data)
                            tempSingleAlbum = SingleAlbum(albumID: albumID, name: name,
                                                          dateCreated: date, timeCreated: time,
                                                          createdBy: createdBy, thumbnail: thumbnail!,
                                                          imagePaths: imagePaths)
                            completion(tempSingleAlbum,nil)
                        }
                    }
                }
            }
        }) { (error) in
            completion(nil,error.localizedDescription)
        }
    }
    
    public func createNewAlbum(albumName: String, albumID: String,
                               _ completion: @escaping(_ singleAlbum: SingleAlbum) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        // Metadata
        let date = Date()
        let calendar = Calendar.current
        //swiftlint:enable all
        let currentDate = "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))"
        let currentTime = "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
        //swiftlint:enable all
        let databaseRef = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).setValue(["Name" : albumName,
                                                                        "Created by": userID,
                                                                        "Date": currentDate,
                                                                        "Time": currentTime,
                                                                        "ImagePaths": [""]])
        let createdAlbum = SingleAlbum(albumID: albumID, name: albumName, dateCreated: currentDate,
                                       timeCreated: currentTime, createdBy: userID,
                                       thumbnail: UIImage(named: "placeholder")!, imagePaths: [""])
        completion(createdAlbum)
    }

    public func addAlbumToUserAlbums(albumIDs: [String],_ completion: @escaping (Bool) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").child(Auth.auth().currentUser!.uid).child("Albums").setValue(albumIDs)
        completion(true)
    }

    public func deleteAlbumsFromUserAlbums(updatedUserAlbums: [String]) {
        let userID = Auth.auth().currentUser?.uid
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").child(userID!).child("Albums").setValue(updatedUserAlbums)
    }
}
