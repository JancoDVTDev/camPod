//
//  ShowingAllUserAlbumsViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/04.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

public class ShowingAllUserAlbumsViewModel {
    
    public init () {
        
    }
    public let user = Auth.auth().currentUser
    
    public func addNewAlbum(newAlbumName: String) {
        let date = Date()
        let calendar = Calendar.current
        let uniqueAlbumID = generateUniqueAlbumID()
        getUserAlbumsArray { (array) in
            var newArray = array
            newArray.append(uniqueAlbumID)
            if let _ = self.user {
                var dbReference: DatabaseReference!
                dbReference = Database.database().reference()
                print(newArray)
                dbReference.child("Users").child(Auth.auth().currentUser!.uid).child("Albums").setValue(newArray)
                dbReference.child("AllAlbumsExisting").child(uniqueAlbumID).setValue(["Name" : newAlbumName, "Created by": Auth.auth().currentUser!.uid, "Date": "\(calendar.component(.day, from: date))/\(calendar.component(.month, from: date))/\(calendar.component(.year, from: date))", "Time": "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"])
            }
        }
    }
    
    public func getUserAlbumsArray(_ completion: @escaping (_ array: [String]) -> Void) {
        var uniqueAlbumIdArray = [String]()
        let databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        databaseRef.child("Users").child(Auth.auth().currentUser!.uid).child("Albums").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let val = snap.value
                print("Fetched: \(val ?? "Error")")
                uniqueAlbumIdArray.append(val as! String)
            }
            completion(uniqueAlbumIdArray)
        }
    }
    
    public func generateUniqueAlbumID() -> String {
        let uniqueString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321abcdefghijklmnopqrstuvwxyz"
        let uniqueChars = Array(uniqueString)
        var compiledUniqueString: String = ""

        var uniqueStringExists = false

        repeat {
            for _ in 0..<25 {
                let randomNumber = Int.random(in: 0..<uniqueChars.count)
                compiledUniqueString += String(uniqueChars[randomNumber])
            }
            //unique Id should be captured in database and double checked so
            //that therr would be no double
            if compiledUniqueString == "1" { //Check from Database if this ID exists
                uniqueStringExists = true
            }
        } while (uniqueStringExists == true)
        
        return compiledUniqueString
    }
}
