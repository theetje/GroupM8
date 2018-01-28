//
//  messageTableViewCell.swift
//  GroupM8
//
//  Created by Thomas De lange on 28-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit

class messageTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var messageWriterLabel: UILabel!
    @IBOutlet weak var messageTimestempLabel: UILabel!
    
    @IBOutlet weak var messageContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Maakt de shadow/card effect.
        messageContent.layer.shadowColor = UIColor.black.cgColor
        messageContent.layer.shadowOpacity = 1
        messageContent.layer.shadowOffset = CGSize.zero
        messageContent.layer.shadowRadius = 2.5
        messageContent.layer.cornerRadius = 5
    }
    
}
