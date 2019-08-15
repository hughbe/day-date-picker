//
//  Int+RoundToNearest.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

class DayDateIntHelpers {
    static let ordinalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
}

internal extension Int {
    func round(toNearest: Int) -> Int{
        let fractionNum = Double(self) / Double(toNearest)
        let roundedNum = Int(floor(fractionNum))
        return roundedNum * toNearest
    }

    var ordinalIndicatorString: String {
        get {
            let stringSelf = "\(self)"
            if let ordinalSelf: String = DayDateIntHelpers.ordinalFormatter.string(from: NSNumber(value: self)) {
                return ordinalSelf.replacingOccurrences(of: stringSelf, with: "")
            }
            return ""
        }
    }
}

