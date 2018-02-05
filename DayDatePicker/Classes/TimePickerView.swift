//
//  TimePickerView.swift
//  DayDatePicker
//
//  Created by Hugh Bellamy on 01/02/2018.
//

import UIKit

@IBDesignable
public class TimePickerView : UIControl {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate var _time: Time!
    fileprivate var _minTime: Time?

    public var minTime: Time? {
        get {
            return _minTime
        } set {
            setMinTime(minTime: newValue, animated: true)
        }
    }

    public var time: Time {
        get {
            return _time
        } set {
            setTime(time: newValue, animated: true)
        }
    }

    public func setTime(hour: Int, minute: Int, animated: Bool) {
        let time = Time(hour: hour, minute: minute)
        setTime(time: time, animated: animated)
    }

    public func setTime(time: Time, animated: Bool) {
        var time = time
        if let minTime = _minTime, time < minTime {
            time = minTime
        }

        time.minute = time.minute.round(toNearest: minuteInterval)
        let reloadMinuteTableView = time.hour != _time.hour
        _time = time
        
        if reloadMinuteTableView {
            minuteTableView.reloadAndLayout()
        }

        if hourTableView.superview != nil {
            hourTableView.scrollToRow(row: time.hour, animated: animated)
            minuteTableView.scrollToRow(row: time.minute / minuteInterval, animated: animated)
        }

        sendActions(for: .editingChanged)
    }

    public func setMinTime(hour: Int, minute: Int, animated: Bool) {
        let minTime = Time(hour: hour, minute: minute)
        setMinTime(minTime: minTime, animated: animated)
    }

    public func setMinTime(minTime: Time?, animated: Bool) {
        _minTime = minTime
        reload()

        if let minTime = minTime, time < minTime {
            setTime(time: minTime, animated: animated)
        }
    }

    @IBInspectable
    public var minuteInterval: NSInteger = 5 {
        willSet {
            if let secondsInMinute = NSCalendar.current.range(of: .second, in: .minute, for: Date()) {
                precondition(newValue >= secondsInMinute.lowerBound && secondsInMinute.upperBound % newValue == 0, "The time interval has to be a positive number. 60 must be divisible by the interval.")
            }
        } didSet {
            minuteTableView.reloadData()
        }
    }

    fileprivate let hourTableView = UITableView()
    fileprivate let minuteTableView = UITableView()
    public let overlayView = UIView()

    fileprivate var rowHeight: CGFloat = 44
    @IBOutlet public var delegate: TimePickerViewDelegate?

    fileprivate var hourRange: Range<Int>!
    fileprivate var minuteRange: Range<Int>!
}

// Layout actions.
extension TimePickerView {
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    fileprivate func setup() {
        if hourTableView.superview != nil {
            return
        }

        setupTableView(tableView: hourTableView)
        setupTableView(tableView: minuteTableView)

        overlayView.backgroundColor = UIColor(red: 0, green: 153 / 255, blue: 102 / 255, alpha: 1)
        overlayView.isUserInteractionEnabled = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.alpha = 0.5
        addSubview(overlayView)

        addConstraints([
            NSLayoutConstraint(item: hourTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: hourTableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: hourTableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: hourTableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0),

            NSLayoutConstraint(item: minuteTableView, attribute: .leading, relatedBy: .equal, toItem: hourTableView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: minuteTableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: minuteTableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: minuteTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),

            NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: rowHeight)
        ])

        if _time == nil {
            let components = Calendar.current.dateComponents([.hour, .minute], from: Date()) as NSDateComponents
            _time = Time(hour: components.hour, minute: components.minute)
        }

        hourRange = Calendar.current.range(of: .hour, in: .day, for: Date())
        minuteRange = Calendar.current.range(of: .minute, in: .hour, for: Date())

        superview?.layoutIfNeeded()
        setTime(time: _time, animated: false)
    }

    private func setupTableView(tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsets(top: (frame.size.height - rowHeight) / 2, left: 0, bottom: (frame.size.height - rowHeight) / 2, right: 0)

        tableView.delegate = self
        tableView.dataSource = self

        addSubview(tableView)
    }
}

// Table view data.
extension TimePickerView : UITableViewDataSource, UITableViewDelegate {
    public func reload() {
        hourTableView.reloadAndLayout()
        minuteTableView.reloadAndLayout()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hourTableView {
            if let hoursInDay = Calendar.current.range(of: .hour, in: .day, for: Date()) {
                hourRange = hoursInDay
                return hoursInDay.count
            }
        } else if tableView == minuteTableView {
            if let minutesInAnHour = Calendar.current.range(of: .minute, in: .hour, for: Date()) {
                minuteRange = minutesInAnHour
                return minutesInAnHour.count / minuteInterval
            }
        }

        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black

        if tableView == hourTableView {
            let hour = hourRange.lowerBound + indexPath.row
            if hour < minHour {
                cell.textLabel?.textColor = UIColor.lightGray
            }

            cell.textLabel?.text = String(hour)

            delegate?.customizeCell(cell: cell, atIndexPath: indexPath, forType: .hour)
        } else if tableView == minuteTableView {
            let minute = minuteRange.lowerBound + indexPath.row * minuteInterval
            let time = Time(hour: hour, minute: minute)
            if let minTime = minTime, time < minTime {
                cell.textLabel?.textColor = UIColor.lightGray
            }

            cell.textLabel?.text = String(time.minute)

            delegate?.customizeCell(cell: cell, atIndexPath: indexPath, forType: .minute)
        }

        return cell;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let tableView = scrollView as? UITableView else {
            return
        }

        if !decelerate {
            alignTableViewToRow(tableView: tableView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }

        alignTableViewToRow(tableView: tableView)
    }

    private func alignTableViewToRow(tableView: UITableView) {
        let row = tableView.getRowScroll()

        if tableView == hourTableView {
            hour = hourRange.lowerBound + row
        } else if tableView == minuteTableView {
            minute = minuteRange.lowerBound + row * minuteInterval
        }
    }
}

// Interface Builder properties.
extension TimePickerView {
    @IBInspectable
    public var minHour: NSInteger {
        get {
            return _minTime?.hour ?? 0
        }
        set {
            setMinTime(hour: newValue, minute: _minTime?.minute ?? 0, animated: true)
        }
    }

    @IBInspectable
    public var minMinute: NSInteger {
        get {
            return _minTime?.minute ?? 0
        }
        set {
            setMinTime(hour: _minTime?.hour ?? 0, minute: newValue, animated: true)
        }
    }

    @IBInspectable
    public var hour: NSInteger {
        get {
            return time.hour
        }
        set {
            setTime(hour: newValue, minute: time.minute, animated: true)
        }
    }

    @IBInspectable
    public var minute: NSInteger {
        get {
            return time.minute
        }
        set {
            setTime(hour: time.hour, minute: newValue, animated: true)
        }
    }
}
