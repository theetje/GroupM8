//
//  backTableViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 11-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit

class backTableViewController: UITableViewController {
    
    // TableArray bevat de koppen van het menu
    var TableArray = [String]()
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Namen van het hamburger menu
        TableArray = ["Chatbox", "Agenda", "Instellingen"]
        
        // Layout:
        // We set the table view header.
//        let cellTableViewHeader = tableView.dequeueReusableCellWithIdentifier(TableViewController.tableViewHeaderCustomCellIdentifier) as! UITableViewCell
//        cellTableViewHeader.frame = CGRectMake(0, 0, self.tableView.bounds.width, self.heightCache[TableViewController.tableViewHeaderCustomCellIdentifier]!)
//        self.tableView.tableHeaderView = cellTableViewHeader
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

                                /* --- Delegate functions nodig voor TableView --- */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
}
