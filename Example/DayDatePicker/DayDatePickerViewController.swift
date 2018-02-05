//
//  DayDatePickerViewController.swift
//  DayDatePicker
//
//  Created by hughbe on 02/01/2018.
//  Copyright (c) 2018 hughbe. All rights reserved.
//

import UIKit
import DayDatePicker

class DayDatePickerViewController: UIViewController {
    @IBOutlet weak var dayDatePickerView: DayDatePickerView!
    @IBOutlet weak var dayDateLabel: UILabel!
    
    @IBAction func setDateTo20February2017(_ sender: Any) {
        dayDatePickerView.setDate(year: 2017, month: 2, day: 20, animated: true)
    }
    
    @IBAction func setMinDateTo25February2017(_ sender: Any) {
        dayDatePickerView.setMinDate(year: 2017, month: 2, day: 25, animated: true)
    }
    
    @IBAction func setOverlayColor(_ sender: Any) {
        dayDatePickerView.overlayView.backgroundColor = UIColor.brown
    }
    
    @IBAction func dayDatePickerChanged(_ sender: DayDatePickerView) {
        dayDateLabel.text = String(format: "%02d/%02d/%04d", sender.day, sender.month, sender.year)
    }
}

