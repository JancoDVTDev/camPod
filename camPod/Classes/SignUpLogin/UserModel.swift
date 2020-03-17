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

// Protocol means that this class must have at least the functions stated in the protocol
public protocol UserModelProtocol: class {
    func login(email: String, password: String, _ completion: @escaping (_ success: Bool, _ user: User?) -> Void)
    func signUp(firstName: String, lastName: String, email: String, password: String,
    _ completion: @escaping (_ user: User?) -> Void)
}

public class UserModel: UserModelProtocol {
    
    public init() {
        
    }

    public func login(email: String, password: String, _ completion: @escaping (_ success: Bool, _ user: User?) -> Void) {
        var albumNames = [String]()
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: "Cannot Log In", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { (_) in
                    print(err?.localizedDescription as Any)
                }))
            } else { //If nothing happens take out of else statement
                let ref: DatabaseReference = Database.database().reference()
                ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    let firstName = value["firstName"] as? String ?? ""
                    let lastName = value["lastName"] as? String ?? ""
                    let albumIDs = value["Albums"] as? [String] ?? [""]
                    
                    for albumID in albumIDs {
                        self.getAlbumNameFromFirebase(albumID: albumID) { (albumName) in
                            albumNames.append(albumName)
                            if albumNames.count == albumIDs.count {
                                completion(true, User(firstName: firstName, lastName: lastName, email: email, albumIDs: albumIDs))
                            }
                        }
                    }
                }
            }
        } 
    }
    
    public func signUp(firstName: String, lastName: String, email: String, password: String,
                       _ completion: @escaping (_ user: User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                print(err?.localizedDescription as Any)
            } else {
                self.createUserInRealtimeDatabase(firstName: firstName, lastName: lastName) { (success) in
                    completion(User(firstName: firstName, lastName: lastName, email: email, albumIDs: [""]))
                }
            }
        }
    }

    public func getAlbumNameFromFirebase(albumID: String, _ completion: @escaping (_ albumName: String) -> Void) {
        let databaseRef: DatabaseReference = Database.database().reference()
        databaseRef.child("AllAlbumsExisting").child(albumID).observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
          let albumName = value?["Name"] as? String ?? ""
          completion(albumName)
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func createUserInRealtimeDatabase(firstName: String, lastName: String, _ completion: @escaping (_ val: Bool) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child("Users").child(Auth.auth().currentUser!.uid).setValue(["firstName": firstName,
                                                                                 "lastName": lastName,
                                                                                 "Albums": [""]])
        completion(true)
    }
}

public struct User {
    public let firstName: String
    public let lastName: String
    public let email: String
    public var albumIDs: [String]
    
    public mutating func appendAlbumIDs(albumID: String) {
        albumIDs.append(albumID)
    }
}


