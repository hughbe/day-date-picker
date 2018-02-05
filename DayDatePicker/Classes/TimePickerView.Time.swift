//
//  TimePickerView.Time.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

import Foundation

public extension TimePickerView {
    public struct Time: Comparable {
        public static func <(lhs: TimePickerView.Time, rhs: TimePickerView.Time) -> Bool {
            if lhs.hour < rhs.hour {
                return true
            } else if lhs.hour == rhs.hour && lhs.minute < rhs.minute {
                return true
            }
            
            return false
        }
        
        public static func ==(lhs: TimePickerView.Time, rhs: TimePickerView.Time) -> Bool {
            return lhs.hour == rhs.hour && lhs.minute == rhs.minute
        }
        
        public var hour: Int {
            willSet {
                if let hoursInADay = Calendar.current.range(of: .hour, in: .day, for: Date()) {
                    precondition(newValue >= hoursInADay.lowerBound && newValue < hoursInADay.upperBound)
                }
            }
        }
        
        public var minute: Int {
            willSet {
                if let minutesInAnHour = Calendar.current.range(of: .minute, in: .hour, for: Date()) {
                    precondition(newValue >= minutesInAnHour.lowerBound && newValue < minutesInAnHour.upperBound)
                }
            }
        }
    }
}
