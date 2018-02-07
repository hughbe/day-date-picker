//
//  TimePickerView.Time.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

import Foundation

public extension TimePickerView {
    public struct Time: Comparable {
        public init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
        
        public init(date: Date) {
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            
            self.hour = components.hour ?? 0
            self.minute = components.minute ?? 0
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
        
        public var date: Date? {
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            
            return Calendar.current.date(from: components)
        }
        
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
        
        public func time(byAddingHour hour: Int, andMinutes minutes: Int) -> Time? {
            guard let date = date else {
                return nil
            }

            var components = DateComponents()
            components.hour = hour
            components.minute = minutes

            guard let addedDate = Calendar.current.date(byAdding: components, to: date) else {
                return nil
            }

            return Time(date: addedDate)
        }
    }
}
