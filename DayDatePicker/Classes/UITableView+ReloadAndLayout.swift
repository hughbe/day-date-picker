//
//  UITableView+ReloadAndLayout.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 05/02/2018.
//

import UIKit

internal extension UITableView {
    func reloadAndLayout() {
        reloadData()
        layoutIfNeeded()
    }
    
    func getRowScroll() -> Int {
        var relativeOffset = CGPoint(x: 0, y: contentOffset.y + contentInset.top)
        relativeOffset.y = min(contentSize.height + contentInset.top, relativeOffset.y)
        
        let row = Int(round(relativeOffset.y / rowHeight))
        return row
    }
    
    func scrollToRow(row: Int, animated: Bool) {
        let scroll = CGFloat(row) * rowHeight - contentInset.top
        setContentOffset(CGPoint(x: 0, y: scroll), animated: animated)
    }
}
