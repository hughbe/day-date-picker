//
//  TimePickerViewController.swift
//  DayDatePicker
//
//  Created by hughbe on 02/01/2018.
//  Copyright (c) 2018 hughbe. All rights reserved.
//

import UIKit
import DayDatePicker

class TimePickerViewController: UIViewController {
    @IBOutlet weak var timePickerView: TimePickerView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func setToTenFifteen(_ sender: Any) {
        timePickerView.setTime(hour: 10, minute: 15, animated: true)
    }

    @IBAction func setMinTimeToTenThirty(_ sender: Any) {
        timePickerView.setMinTime(hour: 10, minute: 30, animated: true)
    }

    @IBAction func setOverlayColor(_ sender: Any) {
        timePickerView.overlayView.backgroundColor = UIColor.brown
    }

    @IBAction func timePickerChanged(_ sender: TimePickerView) {
        timeLabel.text = String(format: "%02d:%02d", sender.hour, sender.minute)
    }
}
