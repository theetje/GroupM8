//
//  findUser.swift
//  GroupM8
//
//  Created by Thomas De lange on 20-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct User {
    var email: String?
    var group: String?
}

class DatabaseQuerys {
    // Database reference
    var ref: DatabaseReference?

    func findUserInfo(completion: @escaping (User) -> ())  {
        // Haal de userID op waaronder info is opgeslagen in de database.
        let userID = Auth.auth().currentUser?.uid
        
        // ref naar de database.
        ref = Database.database().reference()
        
        ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let group = value?["group"] as? String ?? ""
            let email = value?["mail"] as? String ?? ""
            
            let user = User(email: email, group: group)
            completion(user)
        }) { (error) in
            print(error.localizedDescription)
        }
        let user = User(email: "", group: "")
        completion(user)
    }

    func writeEventToDatabase(userGroup: String, dateSetForEvent: String, eventName: String) {
        // Maak input variabelen en ga naar de juiste groep.
        let userGroup = userGroup
        let dateSetForEvent = dateSetForEvent
        let eventName = eventName
        
        // Maak een referenctie naar de database en een eventID
        ref = Database.database().reference()
        let eventID = ref?.child("Groepen").child(userGroup).child("Agenda").childByAutoId()
        
        eventID?.child("date").setValue(dateSetForEvent)
        eventID?.child("eventName").setValue(eventName)
    }
}


