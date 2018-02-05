//
//  Int+RoundToNearest.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

internal extension Int {
    func round(toNearest: Int) -> Int{
        let fractionNum = Double(self) / Double(toNearest)
        let roundedNum = Int(floor(fractionNum))
        return roundedNum * toNearest
    }
    
    var ordinalIndicatorString: String {
        get {
            switch self {
            case 1, 21, 32:
                return "st"
            case 2, 22, 32:
                return "nd"
            case 3, 23, 33:
                return "nd"
            default:
                return "th"
            }
        }
    }
}
