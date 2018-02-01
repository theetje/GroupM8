//
//  calendarTableViewCell.swift
//  GroupM8
//
//  Created by Thomas De lange on 25-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//
// Events worden in deze cellen gezet. Er hoord een .xib bij die ook
// calendarTableViewCell heet.

import UIKit

class calendarTableViewCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var dateID: UILabel!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var contendView: UIView!
    
    let dataBaseQueryInstence = DatabaseQuerys()
    
    // joind eventButton.
    @IBAction func goToEvent(_ sender: Any) {
        self.dataBaseQueryInstence.joinEvent(userGroup: User.shared.group!, eventID: dateID.text!)
        Button.bounce()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateID.isHidden = true
        
        // Geef extra waarde voor de layout.
        contendView.layer.cornerRadius = 5
        Button.layer.cornerRadius = 5
        
        contendView.layer.shadowColor = UIColor.black.cgColor
        contendView.layer.shadowOpacity = 1
        contendView.layer.shadowOffset = CGSize.zero
        contendView.layer.shadowRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
