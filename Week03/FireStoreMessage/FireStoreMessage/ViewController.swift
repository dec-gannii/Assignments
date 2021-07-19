//
//  ViewController.swift
//  FireStoreMessage
//
//  Created by 김가은 on 2021/07/19.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    let db = Firestore.firestore()
    var message: String = ""
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        var ref: DocumentReference? = nil
//        // collection은 여러 개의 document 라고 생각하면 됨
//        // 데이터 추가
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//
//        db.collection("cities").document("LA").setData([
//            "name": "Los Angeles",
//            "state": "CA",
//            "country": "USA"
//        ]) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//        // 데이터 읽기
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//
//        let washingtonRef = db.collection("cities").document("DC")
//        washingtonRef.setData([
//            "name": "Los Angeles",
//            "state": "CA",
//            "country": "USA",
//            "lastUpdated": FieldValue.serverTimestamp(),])
//        // Set the "capital" field of the city 'DC'
//        washingtonRef.updateData([
//            "capital": true
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//
//        // Create an initial document to update.
//        let frankDocRef = db.collection("users").document("frank")
//        frankDocRef.setData([
//            "name": "Frank",
//            "favorites": [ "food": "Pizza", "color": "Blue", "subject": "recess" ],
//            "age": 12
//            ])
//
//        // To update age and favorite color:
//        db.collection("users").document("frank").updateData([
//            "age": 13,
//            "favorites.color": "Red"
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
        
    }
 
    
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        print("clicked")
        let message = textField.text!
        
        var ref: DocumentReference? = nil
        // collection은 여러 개의 document 라고 생각하면 됨
        // 데이터 추가
        ref = db.collection("messages").addDocument(data: [
            "from": "Kim Ga Eun",
            "message": message,
            "recieve Time": FieldValue.serverTimestamp(),
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
}



