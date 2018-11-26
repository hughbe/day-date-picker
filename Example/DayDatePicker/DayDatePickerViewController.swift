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
    
    // MARK: - Outlets
    @IBOutlet weak var dayDatePickerView: DayDatePickerView!
    @IBOutlet weak var dayDateLabel: UILabel!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        dayDatePickerView.delegate = self
        dayDatePickerView.setMaxDate(Date(), animated: true)
        dayDatePickerView.setFeedback(hasHapticFeedback: false, hasSound: false)
        dayDatePickerView.backgroundColor = UIColor.lightGray
    }
    
    // MARK: - Actions
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

// MARK: - Day Date Picker View Delegate
extension DayDatePickerViewController: DayDatePickerViewDelegate {    
    func didSelectDate(day: NSInteger, month: NSInteger, year: NSInteger) {
        dayDateLabel.text = String(format: "%02d/%02d/%04d", day, month, year)
    }
}
