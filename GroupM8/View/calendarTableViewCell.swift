//
//  calendarTableViewCell.swift
//  GroupM8
//
//  Created by Thomas De lange on 25-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit

class calendarTableViewCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBAction func goToEvent(_ sender: Any) {
        print("index is:")
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
