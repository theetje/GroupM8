//
//  databaseQuerys.swift
//  GroupM8
//
//  Created by Thomas De lange on 21-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseQuerys {
    // Database reference
    var ref: DatabaseReference?
    
    // Functie met completion handler omdat anders de retrun altijd leeg is:
    func findUserInfo(completion: @escaping (User) -> ())  {
        // Haal de userID op waaronder info is opgeslagen in de database.
        let userID = Auth.auth().currentUser?.uid
        
        // ref naar de database.
        ref = Database.database().reference()
        
        // Haald de data uit Users onderdeel et de unique userID
        ref?.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value as Dictionary object.
            let value = snapshot.value as? NSDictionary
            let group = value?["group"] as? String ?? ""
            let email = value?["mail"] as? String ?? ""
            
            // gelukt mooi... maak een user object.
            let user = User(email: email, group: group)
            completion(user)
        }) { (error) in
            // Error handeling.
            print(error.localizedDescription)
        }
    }
    
    func getCalendarEvents(userGroup: String, completion: @escaping ([Event]) -> ()) {
        ref = Database.database().reference()
        var events = [Event]()
        
        ref?.child("Groepen").child(userGroup).child("Agenda").observe(.value, with: { (snapshot) in
            // Haal alle data op van de server
            let calandarEvents = snapshot.value as? [String:AnyObject]
           
            for calandarEvent in (calandarEvents?.values)! {
                let date = calandarEvent["date"] as? String ?? ""
                let eventName = calandarEvent["eventName"] as? String ?? ""

                let event = Event(date: date, eventName: eventName)
                events.append(event)
            }
            completion(events)
        }) { (error) in
            // Error handeling.
            print(error.localizedDescription)
        }
    }
    
    // Schrijf een nieuw evenement naar de database.
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
    
    // Schrijf een nieuw evenement naar de database.
    func writeNewUserToDatabase(userGroup: String, userMail: String) {
        // Maak input variabelen en ga naar de juiste groep.
        let userGroup = userGroup
        let userMail = userMail
        
        let userID = Auth.auth().currentUser?.uid
        
        // Maak een referenctie naar de database en een eventID
        ref = Database.database().reference()
        let newUserRef = ref?.child("Users").child(userID!)
        
        newUserRef?.child("group").setValue(userGroup)
        newUserRef?.child("mail").setValue(userMail)
    }
}
