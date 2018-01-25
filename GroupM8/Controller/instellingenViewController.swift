//
//  instellingenViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 25-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import FirebaseAuth

class instellingenViewController: UIViewController {

    // Outlets:
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var welkomeNameLabel: UILabel!
    
    override func viewDidLoad() {
        welkomeNameLabel.text = "Welkom \(User.shared.chatName ?? "Gebruiker")"
        super.viewDidLoad()
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
