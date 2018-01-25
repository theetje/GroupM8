//
//  chatboxViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 16-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import FirebaseAuth

class chatboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Maak array die berichten bevat.
    var MessageArray = [Message]()
    
    // Database clas instance
    let databaseQuerysInstance = DatabaseQuerys()
    
    // Outlets:
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var messageTextField: UITextField!
    
    // Actions
    @IBAction func sendMessage(_ sender: Any) {
        // Controller of er een bericht is geschreven.
        if messageTextField.text != "" {
            databaseQuerysInstance.writeMessageToDatabase(userGroup: User.shared.group!, userChatName: User.shared.chatName!, message: self.messageTextField.text!)
            
            // Maak het text veld weer leeg.
            self.messageTextField.text = ""
        } else {
            print("TextField is empty")
        }
    }
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programmatic link for tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Haal de evenementen op uit de databse.
        databaseQuerysInstance.getMessages(userGroup: User.shared.group!, completion: { messagesFromDatabase in
            if messagesFromDatabase.count > 0 {
                var tempArray = [Message]()
                for message in messagesFromDatabase {
                    tempArray.append(message)
                }
                self.MessageArray = tempArray
                
                // Omdate je geen langzame app wil async data ophalen.
                self.tableView.reloadData()
            } else {
                print("Berichten niet opgehaald")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Functions:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        // Sorteer de berichten van oud naar nieuw en keer om.
        MessageArray.sort(by: { $0.TimeStamp?.compare($1.TimeStamp!) == .orderedAscending })
        MessageArray.reverse()
        
        // Zet berichten in de cell.
        if let messageText = MessageArray[indexPath.row].MessageText {
            cell.textLabel?.text = messageText
        }
        
        if let messageWriter = MessageArray[indexPath.row].MessageWriter {
            cell.detailTextLabel?.text = messageWriter
        }
        
        return cell
    }
}
