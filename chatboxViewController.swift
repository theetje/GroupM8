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
    
    // Test variabelen
//    let testArray = ["first" : "some description", "second": "nog meer info", "third": "laatste info"]
    var MessageArray = [Message]()
    
    // Outlets:
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var messageTextField: UITextField!
    
    // Actions
    @IBAction func sendMessage(_ sender: Any) {
        
        if messageTextField.text != "" {
            let DatabaseQuerysInstanse = DatabaseQuerys()
            
            DatabaseQuerysInstanse.findUserInfo(completion: { userInfo in
                DatabaseQuerysInstanse.writeMessageToDatabase(userGroup: userInfo.group!, userChatName: userInfo.chatName!, message: self.messageTextField.text!)
                // Maak het text veld weer leeg.
                self.messageTextField.text = ""
                
            })
        } else {
            print("TextField is empty")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programmatic link for tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let DatabaseQuerysInstance = DatabaseQuerys()
        
        DatabaseQuerysInstance.findUserInfo() { userInfo in
            let user = userInfo
            self.MessageArray.removeAll()
            // Haal de evenementen op uit de databse.
            DatabaseQuerysInstance.getMessages(userGroup: user.group!, completion: { messagesFromDatabase in
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

        MessageArray.sort(by: { $0.TimeStamp?.compare($1.TimeStamp!) == .orderedAscending })
        MessageArray.reverse()
        if let messageText = MessageArray[indexPath.row].MessageText {
            cell.textLabel?.text = messageText
        }
        
        if let messageWriter = MessageArray[indexPath.row].MessageWriter {
            cell.detailTextLabel?.text = messageWriter
        }
        
        return cell
    }
    
    // Overrides:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
