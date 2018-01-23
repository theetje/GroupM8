//
//  User.swift
//  GroupM8
//
//  Created by Thomas De lange on 21-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import Foundation

// Event struct zoals ze staan in de database
struct User {
    static var shared = User()
    
    var email: String?
    var group: String?
    var chatName: String?
}
