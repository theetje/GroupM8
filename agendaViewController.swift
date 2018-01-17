//
//  agendaViewController.swift
//  GroupM8
//
//  Created by Thomas De lange on 16-01-18.
//  Copyright © 2018 Thomas De lange. All rights reserved.
//

import UIKit
import JTAppleCalendar

class agendaViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // Outlets:
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    @IBOutlet weak var yearLable: UILabel!
    @IBOutlet weak var monthLable: UILabel!
    
    // Functions:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // collectionView hoord bij protocol
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // collectrionViewCell hoord bij protocol
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)

        return cell
    }
    
    // Overrides:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup van de cell waar 1 dag zich in bevind.
        setupCalenderView()
        
        // De functies voor het hamburger menu.
        hamburgerButton.target = self.revealViewController()
        hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setupCalenderView() {
        // setup van de cell waar 1 dag zich in bevind.
        calenderView.minimumInteritemSpacing = 0
        calenderView.minimumInteritemSpacing = 0
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? calendarCollectionViewCell else { return }
        
        if cellState.isSelected {
            validCell.dateLable.textColor = UIColor.darkGray
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLable.textColor = UIColor.black
            } else {
                validCell.dateLable.textColor = UIColor.gray
            }
        }
        
    }
    func handleCellSelected(view: JTAppleCell?, cellstate: CellState) {
        guard let validCell = view as? calendarCollectionViewCell else { return }
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension agendaViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! calendarCollectionViewCell
        cell.dateLable.text = cellState.text
        
        // functies die in gang gaan bij het starten van de app.
        handleCellSelected(view: cell, cellstate: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // Laat de geselecteerde cell zien
        // functies die bij selectie gebruikt worden.
        handleCellSelected(view: cell, cellstate: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // functies die bij deselectie gebruikt worden.
        handleCellSelected(view: cell, cellstate: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        yearLable.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        
        monthLable.text = formatter.string(from: date)
    }
}

// Extensions:
extension agendaViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy mm dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2018 01 01")
        let endDate = dateFormatter.date(from: "2020 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }

    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }
}

