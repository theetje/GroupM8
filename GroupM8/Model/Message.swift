//
//  Message.swift
//  GroupM8
//
//  Created by Thomas De lange on 23-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//
// MessageObject gebruikt voor transitie van en naar database van berichten.

import Foundation

// Event struct zoals ze staan in de database
struct Message {
    var MessageText: String?
    var MessageWriter: String?
    var TimeStamp: String?
}
