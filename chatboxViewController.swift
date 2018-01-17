//
//  chatboxViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 16-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit

class chatboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets:
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    // Functions:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        // Configure the cell...
    
        return cell
    }
    
    // Overrides:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
