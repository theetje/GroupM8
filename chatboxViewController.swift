//
//  chatboxViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 16-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//
// ViewController van de chatbox. Meeste gebeurt in viewDidLoad en de tableViewController.

import UIKit
import FirebaseAuth

class chatboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Maak array die berichten bevat.
    var MessageArray = [Message]()

    // Date formatter object.
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    // Outlets:
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var messageTextField: UITextField!
    
    // Actions
    @IBAction func sendMessage(_ sender: Any) {
        // Controller of er een bericht is geschreven.
        if messageTextField.text != "" {
            DatabaseQuerys.shared.writeMessageToDatabase(userGroup: User.shared.group!, userChatName: User.shared.chatName!, message: self.messageTextField.text!)
            
            // Maak het text veld weer leeg.
            self.messageTextField.text = ""
        } else {
            print("TextField is empty")
        }
    }
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Layout:
        // Connect het nib (xib) bestand.
        let nib = UINib(nibName: "messageTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "messageCell")
        // Haald de shadow onderaan de navigatie balk
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        // Beweeg omhoog als toetsenbord verschrijnt.
        addKeyboardNotifications()
        
        // Programmatic link for tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Haal de evenementen op uit de databse.
        DatabaseQuerys.shared.getMessages(userGroup: User.shared.group!, completion: { messagesFromDatabase in
            if messagesFromDatabase.count > 0 {
                var messageArray = [Message]()
                for message in messagesFromDatabase {
                    messageArray.append(message)
                }
                self.MessageArray = messageArray
                
                // Omdate je geen langzame app wil async data ophalen.
                self.tableView.reloadData()
            } else {
                self.showAlert(title: "Oeps!", message: "No messages could be loaded form the server.")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageTableViewCell

        // Disable cell selection.
        cell.selectionStyle = .none
        
        // Sorteer de berichten van oud naar nieuw en keer om.
        MessageArray.sort(by: { $0.TimeStamp?.compare($1.TimeStamp!) == .orderedAscending })
        MessageArray.reverse()
        
        cell.messageContentLabel?.text = MessageArray[indexPath.row].MessageText!
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        let dateDate = formatter.date(from: MessageArray[indexPath.row].TimeStamp!)
        formatter.dateFormat = "yyyy MM dd HH:mm:ss" 
        cell.messageTimestempLabel?.text = formatter.string(from: dateDate!)
        cell.messageWriterLabel?.text = MessageArray[indexPath.row].MessageWriter!
        
        return cell
    }
}
