//
//  UserModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/03.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol UserModelProtocol: class {
    func signIn(_ completion: @escaping (_ val: Bool) -> Void)
    func createUser(_ completion: @escaping (_ val: Bool) -> Void)
}

public class UserModel {

    public var name: String?
    public var surname: String?
    public var email: String?
    public var password: String?
    
    public var albumIDs: [String]?
    public var albumNames: [String]?
    
    init() {
        
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        //Log user in with firebase and retrieving the data to set the other variables inside this class
        //Func - Login
    }
    
    init(name: String, and surname: String, with email: String, and password: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
    }
    
    public func signIn(_ completion: @escaping (_ val: Bool) -> Void) {
        Auth.auth().signIn(withEmail: self.email!, password: self.password!) { (result, err) in
            if err != nil {
                print(err?.localizedDescription as Any)
            } else {
            }
            self.retrieveAndSetUserInfo { (_ success) in
                if success {
                    print("User Model setted Values through create")
                    completion(true)
                }
            }
        }
    }
    
    public func createUser(_ completion: @escaping (_ val: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email!, password: password!) { (result, err) in
            if err != nil {
                print(err?.localizedDescription as Any)
            } else {
            }
            self.createUserInRealtimeDatabase { (_ success) in
                if success {
                    print("User data written to Realtime Database")
                    completion(true)
                }
            }
        }
    }
    
    func createUserInRealtimeDatabase(_ completion: @escaping (_ val: Bool) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").child(Auth.auth().currentUser!.uid).setValue(["firstName": self.name,
                                                                                 "lastName": surname])
        completion(true)
    }
    
    func retrieveAndSetUserInfo(_ completion: @escaping (_ val: Bool) -> Void) {
        let userID = Auth.auth().currentUser?.uid
        let databaseRef: DatabaseReference = Database.database().reference()
        databaseRef.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
            self.name = value?["firstName"] as? String ?? ""
            self.surname = value?["surname"] as? String ?? ""
            self.getUserAlbumsArray { (array) in
                self.albumIDs = array
                self.getAlbumNamesFromDatabase(albumIDArray: self.albumIDs!) { (albumNamesFromDb) in
                    self.albumNames = albumNamesFromDb
                }
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        completion(true)
    }
    
    public func getUserAlbumsArray(_ completion: @escaping (_ array: [String]) -> Void) {
        var uniqueAlbumIdArray = [String]()
        let databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        databaseRef.child("Users").child(Auth.auth().currentUser!.uid).child("Albums").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let val = snap.value
                print("UserModel - Fetched AlbumID: \(val ?? "Error")")
                uniqueAlbumIdArray.append(val as! String)
            }
            completion(uniqueAlbumIdArray)
        }
    }
    
    public func getAlbumNamesFromDatabase(albumIDArray: [String], _ completion: @escaping (_ albumNamesArray: [String]) -> Void) {
        let databaseRef: DatabaseReference = Database.database().reference()
        var albumNames = [String]()
        for item in albumIDArray {
            databaseRef.child("AllAlbumsExisting").child(item).child("Name").observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let name = snap.value
                    print("UserModel - Fetched Album Name: \(name ?? "Error in name")")
                    albumNames.append(name as! String)
                }
                completion(albumNames)
            }
        }
    }
}


