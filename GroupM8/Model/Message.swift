//
//  Message.swift
//  GroupM8
//
//  Created by Thomas De lange on 23-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import Foundation

// Event struct zoals ze staan in de database
struct Message {
    var MessageText: String?
    var MessageWriter: String?
    var TimeStamp: String?
    
//    // Sorteer de berichten a.d.h.v. de datum.
//    func sortMessagesByDate() {
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ" // yyyy-MM-dd"
//        
//        for item in tempArray {
//            let tempItem = dateFormatter.date(from: item.TimeStamp!)
//            item.TimeStamp = tempItem
//        }
//        
//        var ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
//        
//        print(ready)
//        return ready
//    }
}
