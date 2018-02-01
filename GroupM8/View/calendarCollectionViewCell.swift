//
//  calendarCollectionViewCell.swift
//  GroupM8
//
//  Created by Thomas De lange on 17-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//
// Bestand is de content van de cellen in de collectionViewController. Bevat de dagen van
// de maand kleurtje als die databevar (dotSelecter) en een overview die laat zien dat iets is
// geselecteerd. 

import JTAppleCalendar

class calendarCollectionViewCell: JTAppleCell {
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dotSelecter: UIView!
}
