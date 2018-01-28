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
    
    // Date formatter object.
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        return dateFormatter
    }()
    
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
            let group = value?["Group"] as? String ?? ""
            let email = value?["Mail"] as? String ?? ""
            let chatName = value?["ChatName"] as? String ?? ""
            
            // gelukt mooi... maak een user object.
            let user = User(email: email, group: group, chatName: chatName)
            completion(user)
        }) { (error) in
            // Error handeling.
            print(error.localizedDescription)
        }
    }
    
    // Haal evenementen op voor de calender.
    func getCalendarEvents(userGroup: String, completion: @escaping ([Event]) -> ()) {
        ref = Database.database().reference()
        var events = [Event]()
        
        ref?.child("Group").child(userGroup).child("Agenda").observe(.value, with: { (snapshot) in
            // Haal alle data op van de server
            if let calandarEvents = snapshot.value as? [String:AnyObject] {
                // Verwerk de data
                for calandarEvent in (calandarEvents.values) {
                    let eventKey = calandarEvent["EventKey"] as? String ?? "no id"
                    let date = calandarEvent["Date"] as? String ?? ""
                    let eventName = calandarEvent["EventName"] as? String ?? ""
                    let eventDesctiption = calandarEvent["eventDesctiption"] as? String ?? ""
                    let partisipents = calandarEvent["partisipents"] as? Int ?? 1
                    
                    let event = Event(date: date, eventName: eventName, eventDesctiption: eventDesctiption, partisipents: partisipents, eventKey: eventKey)
                    events.append(event)
                }
            } else {
                print("Events zijn niet opgehaald.")
            }
            completion(events)
        }) { (error) in
            // Error handeling.
            print(error.localizedDescription)
        }
    }
    
    // Haal de berichten op.
    func getMessages(userGroup: String, completion: @escaping ([Message]) -> ()) {
        ref = Database.database().reference()
        var messages = [Message]()
        ref?.child("Group").child(userGroup).child("Messageboard").observe(.value, with: { (snapshot) in
            if let message = snapshot.value as? [String: AnyObject] {
                // verwerk data
                for messageMetaData in message.values {
                    let MessageText = messageMetaData["MessageText"] as? String ?? ""
                    let MessageWriter = messageMetaData["MessageWriter"] as? String ?? ""
                    let TimeStamp = messageMetaData["TimeStamp"] as? String ?? ""
                    
                    let message = Message(MessageText: MessageText, MessageWriter: MessageWriter, TimeStamp: TimeStamp)
                    messages.append(message)
                }
            } else {
                print("Er zijn geen berichten opgehaald.")
            }
            completion(messages)
            
            // Maak berichten leeg zodat ze niet dubbel verschijenen.
            messages.removeAll()
        }) {(error) in
            // Error handling
            print(error.localizedDescription)
        }
    }
    
    func getAttendeesEvent(userGroup: String, eventID: String, completion: @escaping (UInt) -> ()){
        ref = Database.database().reference()
        
        _ = ref?.child("Group").child(userGroup).child("Attendees").child(eventID).observe(.value, with: { (snapshot) in
            let attendees = snapshot.childrenCount
            completion(attendees)
        })
    }
    
    // Schrijf een nieuw evenement naar de database.
    func writeEventToDatabase(userGroup: String, dateSetForEvent: String, eventName: String, eventDescription: String) {
        // Initieer ref naar de datbase.
        ref = Database.database().reference()
        let eventRoot = ref?.child("Group").child(userGroup).child("Agenda").childByAutoId()
        let eventKey = eventRoot?.key
        let userID = Auth.auth().currentUser?.uid
        
        eventRoot?.child("EventKey").setValue(eventKey)
        eventRoot?.child("Date").setValue(dateSetForEvent)
        eventRoot?.child("EventName").setValue(eventName)
        eventRoot?.child("eventDesctiption").setValue(eventDescription)
        eventRoot?.child("partisipents").setValue("1")
        eventRoot?.child("Deelnemers").child(userID!)
    }
    
    // Zet een gebruiker op de lijst met aanwezigen.
    func joinEvent(userGroup: String, eventID: String) {
        // Initieer ref naar database.
        ref = Database.database().reference()
        let eventRoot = ref?.child("Group").child(userGroup).child("Attendees").child(eventID)
        let userID = Auth.auth().currentUser?.uid
        
        eventRoot?.child(userID!).setValue("Y")
    }
    
    // Schrijf een nieuwe gebruiker naar de database.
    func writeNewUserToDatabase(userGroup: String, userMail: String, chatName: String) {
        // Initieer ref naar de datbase.
        let userID = Auth.auth().currentUser?.uid
        
        // Maak een referenctie naar de database en een userID
        ref = Database.database().reference()
        let newUserRef = ref?.child("Users").child(userID!)
        
        newUserRef?.child("Group").setValue(userGroup)
        newUserRef?.child("Mail").setValue(userMail)
        newUserRef?.child("ChatName").setValue(chatName)
    }
    
    // Schrijf een bericht op het berichtenbord.
    func writeMessageToDatabase(userGroup: String, userChatName: String, message: String) {
        // Initieer ref naar de datbase.
        ref = Database.database().reference()
        let newMessageboardRef = ref?.child("Group").child(userGroup).child("Messageboard").childByAutoId()
        let timestamp = Date()
        
        let formatedTime = formatter.string(from: timestamp)
        
        newMessageboardRef?.child("MessageText").setValue(message)
        newMessageboardRef?.child("MessageWriter").setValue(userChatName)
        newMessageboardRef?.child("TimeStamp").setValue(formatedTime)
    }
    
}
