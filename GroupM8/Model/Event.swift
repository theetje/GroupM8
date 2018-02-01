//
//  Event.swift
//  GroupM8
//
//  Created by Thomas De lange on 21-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//
// EventObject gebruikt voor transitie van en naar database van events.

import Foundation

// Event struct zoals ze staan in de database
struct Event {
    var date: String?
    var eventName: String?
    var eventDesctiption: String?
    var eventKey: String?
}
