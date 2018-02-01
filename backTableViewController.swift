//
//  backTableViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 11-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//
// De backand van het hamburger menu.
// Bron: https://github.com/John-Lluch/SWRevealViewController

import UIKit
import FirebaseAuth

class backTableViewController: UITableViewController {
    
    // TableArray bevat de koppen van het menu
    var TableArray = [String]()
    
    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            // Maak shared User leeg.
            User.shared.chatName = ""
            User.shared.email = ""
            User.shared.group = ""
            print("Uitloggen gelukt")
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        // Doe de segueWay.
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout:
        // Namen van het hamburger menu
        TableArray = ["Chatbox", "Agenda", "Instellingen", "Uitloggen"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
                                /* --- Delegate functions nodig voor TableView --- */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
        
        cell.detailTextLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
}
