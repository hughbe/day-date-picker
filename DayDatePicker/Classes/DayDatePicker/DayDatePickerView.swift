//
//  DayDatePickerView
//  DayDatePicker
//
//  Created by Hugh Bellamy on 01/02/2018.
//

import UIKit

@IBDesignable
public class DayDatePickerView: UIControl {
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Private Property
    fileprivate var _date: Date!
    fileprivate var _minDate: Date?
    fileprivate var _maxDate: Date?
    fileprivate var _textColor: UIColor?
    fileprivate var _textFont: UIFont?
    public let overlayView = UIView()

    // MARK: - Table View Property
    fileprivate let dayTableView = UITableView()
    fileprivate let monthTableView = UITableView()
    fileprivate let yearTableView = UITableView()
    fileprivate var rowHeight: CGFloat = 44
    fileprivate var yearRange: Range<Int>!
    fileprivate var monthRange: Range<Int>!
    fileprivate var dayRange: Range<Int>!
    
    public var dayFormatter = DateFormatter(format: "EEE d") {
        didSet {
            dayTableView.reloadData()
        }
    }
    
    public var monthFormatter = DateFormatter(format: "MMM") {
        didSet {
            monthTableView.reloadData()
        }
    }
    
    public var yearFormatter = DateFormatter(format: "yyyy") {
        didSet {
            yearTableView.reloadData()
        }
    }
    
    // MARK: - Delegate
    @IBOutlet public var delegate: DayDatePickerViewDelegate?

    // MARK: - Public Property
    public var minDate: Date? {
        get {
            return _minDate
        } set {
            setMinDate(minDate: newValue, animated: true)
        }
    }
    
    public var maxDate: Date? {
        get {
            return _minDate
        } set {
            setMaxDate(maxDate: newValue, animated: true)
        }
    }

    public var date: Date {
        get {
            return _date
        } set {
            setDate(date: newValue, animated: true)
        }
    }
    
    public var textFont: UIFont {
        get {
            return _textFont ?? UIFont.systemFont(ofSize: 20)
        } set {
            setTextWith(font: newValue, color: _textColor)
        }
    }
    
    public var textColor: UIColor {
        get {
            return _textColor ?? .black
        } set {
            setTextWith(font: textFont, color: newValue)
        }
    }

    public var showOrdinalIndicator = true {
        didSet {
            dayTableView.reloadData()
        }
    }

    public func setDate(year: Int, month: Int, day: Int, animated: Bool) {
        let date = Date(year: year, month: month, day: day)
        setDate(date: date, animated: animated)
    }

    public func setDate(date: Foundation.Date, animated: Bool) {
        let dateDate = Date(date: date)
        setDate(date: dateDate, animated: animated)
    }

    // MARK: - Public methods
    public func setDate(date: Date, animated: Bool) {
        var date = date
        if let minTime = _minDate, date < minTime {
            date = minTime
        } else if let maxDate = _maxDate, date > maxDate {
            date = maxDate
        }

        let reloadMonthTableView = date.year != _date.year
        let reloadDayTableView = reloadMonthTableView || date.month != _date.month
        _date = date

        if reloadMonthTableView {
            monthTableView.reloadAndLayout()
        }
        if reloadDayTableView {
            dayTableView.reloadAndLayout()
        }

        if dayTableView.superview != nil {
            dayTableView.scrollToRow(row: date.day - dayRange.lowerBound, animated: animated)
            monthTableView.scrollToRow(row: date.month - monthRange.lowerBound, animated: animated)
            yearTableView.scrollToRow(row: date.year - yearRange.lowerBound, animated: animated)
        }

        sendActions(for: .editingChanged)
    }

    // MARK: - Set Min Date
    public func setMinDate(year: Int, month: Int, day: Int, animated: Bool) {
        let minDate = Date(year: year, month: month, day: day)
        setMinDate(minDate: minDate, animated: animated)
    }

    public func setMinDate(minDate: Foundation.Date, animated: Bool) {
        let minDateDate = Date(date: minDate)
        setMinDate(minDate: minDateDate, animated: animated)
    }

    public func setMinDate(minDate: Date?, animated: Bool) {
        _minDate = minDate
        reload()

        if let minDate = minDate, date < minDate {
            setDate(date: minDate, animated: true)
        }
    }
    
    // MARK: - Set Max Date
    public func setMaxDate(year: Int, month: Int, day: Int, animated: Bool) {
        let maxDate = Date(year: year, month: month, day: day)
        setMaxDate(maxDate: maxDate, animated: true)
    }
    
    public func setMaxDate(maxDate: Foundation.Date, animated: Bool) {
        let maxDateDate = Date(date: maxDate)
        setMaxDate(maxDate: maxDateDate, animated: animated)
    }
    
    public func setMaxDate(maxDate: Date?, animated: Bool) {
        _maxDate = maxDate
        reload()
        
        if let maxDate = maxDate, date > maxDate {
            setDate(date: maxDate, animated: true)
        }
    }
    
    // MARK: - Set Text
    public func setTextWith(font: UIFont?, color: UIColor?) {
        _textFont = font ?? UIFont.systemFont(ofSize: 20)
        _textColor = color ?? .black
        
        reload()
    }
}

// Layout actions.
extension DayDatePickerView {
    // MARK: - Override Interface Builder
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentInset = UIEdgeInsets(top: (frame.size.height - rowHeight) / 2, left: 0, bottom: (frame.size.height - rowHeight) / 2, right: 0)
        dayTableView.contentInset = contentInset
        monthTableView.contentInset = contentInset
        yearTableView.contentInset = contentInset
        
        setDate(date: _date, animated: false)
    }

    // MARK: - Setup
    fileprivate func setup() {
        if yearTableView.superview != nil {
            return
        }

        setupTableView(tableView: dayTableView)
        setupTableView(tableView: monthTableView)
        setupTableView(tableView: yearTableView)

        overlayView.backgroundColor = UIColor(red: 0, green: 153 / 255, blue: 102 / 255, alpha: 1)
        overlayView.isUserInteractionEnabled = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.alpha = 0.5
        addSubview(overlayView)

        addConstraints([
            NSLayoutConstraint(item: dayTableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: dayTableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: dayTableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: dayTableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.4, constant: 0),

            NSLayoutConstraint(item: monthTableView, attribute: .leading, relatedBy: .equal, toItem: dayTableView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: monthTableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: monthTableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: monthTableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1 / 3, constant: 0),

            NSLayoutConstraint(item: yearTableView, attribute: .leading, relatedBy: .equal, toItem: monthTableView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: yearTableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: yearTableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: yearTableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),

            NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: rowHeight)
            ])

        if _date == nil {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Foundation.Date()) as NSDateComponents
            _date = Date(year: components.year, month: components.month, day: components.day)
        }

        dayRange = Calendar.current.range(of: .day, in: .month, for: _date.date)
        monthRange = Calendar.current.range(of: .month, in: .year, for: _date.date)
        yearRange = Calendar.current.range(of: .year, in: .era, for: _date.date)
    }

    private func setupTableView(tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white

        tableView.delegate = self
        tableView.dataSource = self

        tableView.scrollsToTop = false

        addSubview(tableView)
    }
}

// MARK: - Table View Data Source
extension DayDatePickerView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dayTableView {
            if let daysInAMonth = Calendar.current.range(of: .day, in: .month, for: date.date) {
                dayRange = daysInAMonth
                return daysInAMonth.count
            }
        } else if tableView == monthTableView {
            if let monthsInAYear = Calendar.current.range(of: .month, in: .year, for: date.date) {
                monthRange = monthsInAYear
                return monthsInAYear.count
            }
        } else if tableView == yearTableView {
            if let yearsInAnEra = Calendar.current.range(of: .year, in: .era, for: date.date) {
                yearRange = yearsInAnEra
                return yearsInAnEra.count
            }
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = textFont
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = textColor
        
        if tableView == dayTableView {
            let date = Date(year: year, month: month, day: dayRange.lowerBound + indexPath.row)
            if let minDate = minDate, date < minDate {
                cell.textLabel?.textColor = UIColor.lightGray
            } else if let maxDate = maxDate, date > maxDate {
                cell.textLabel?.textColor = UIColor.lightGray
            }
            
            var dayString = dayFormatter.string(from: date.date)
            if showOrdinalIndicator {
                dayString.append(date.day.ordinalIndicatorString)
            }
            
            cell.textLabel?.text = dayString
            
            delegate?.customizeCell(cell: cell, atIndexPath: indexPath, forType: .day)
        } else if tableView == monthTableView {
            let month = monthRange.lowerBound + indexPath.row
            if year < minYear || (year == minYear && month < minMonth) {
                cell.textLabel?.textColor = UIColor.lightGray
            } else if year > maxYear || (year == maxYear && month > maxMonth) {
                cell.textLabel?.textColor = UIColor.lightGray
            }
            
            let date = Date(year: year, month: month, day: 1)
            cell.textLabel?.text = monthFormatter.string(from: date.date)
            
            delegate?.customizeCell(cell: cell, atIndexPath: indexPath, forType: .month)
        } else if tableView == yearTableView {
            let year = yearRange.lowerBound + indexPath.row
            if year < minYear {
                cell.textLabel?.textColor = UIColor.lightGray
            } else if year > maxYear {
                cell.textLabel?.textColor = UIColor.lightGray
            }
            
            let date = Date(year: year, month: 1, day: 1)
            cell.textLabel?.text = yearFormatter.string(from: date.date)
            
            delegate?.customizeCell(cell: cell, atIndexPath: indexPath, forType: .year)
        }
        
        return cell
    }
}

// Table view data.
extension DayDatePickerView: UITableViewDelegate {
    public func reload() {
        dayTableView.reloadAndLayout()
        monthTableView.reloadAndLayout()
        yearTableView.reloadAndLayout()
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

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {
            return
        }
        
        alignTableViewToRow(tableView: tableView)
    }

    private func alignTableViewToRow(tableView: UITableView) {
        let row = tableView.getRowScroll()

        if tableView == dayTableView {
            day = dayRange.lowerBound + row
        } else if tableView == monthTableView {
            month = monthRange.lowerBound + row
        } else if tableView == yearTableView {
            year = yearRange.lowerBound + row
        }
        
        delegate?.didSelectDate(day: day, month: month, year: year)
    }
}

// Interface Builder properties.
extension DayDatePickerView {
    @IBInspectable
    public var minYear: NSInteger {
        get {
            return _minDate?.year ?? 0
        }
        set {
            setMinDate(year: newValue, month: _minDate?.month ?? 0, day: _minDate?.day ?? 0, animated: true)
        }
    }

    @IBInspectable
    public var minMonth: NSInteger {
        get {
            return _minDate?.month ?? 0
        }
        set {
            setMinDate(year: _minDate?.year ?? 0, month: newValue, day: _minDate?.day ?? 0, animated: true)
        }
    }

    @IBInspectable
    public var minDay: NSInteger {
        get {
            return _minDate?.day ?? 0
        }
        set {
            setMinDate(year: _minDate?.year ?? 0, month: _minDate?.month ?? 0, day: newValue, animated: true)
        }
    }
    
    @IBInspectable
    public var maxYear: NSInteger {
        get {
            return _maxDate?.year ?? 0
        }
        set {
            setMinDate(year: newValue, month: _maxDate?.month ?? 0, day: _maxDate?.day ?? 0, animated: true)
        }
    }
    
    @IBInspectable
    public var maxMonth: NSInteger {
        get {
            return _maxDate?.month ?? 0
        }
        set {
            setMinDate(year: _maxDate?.year ?? 0, month: newValue, day: _maxDate?.day ?? 0, animated: true)
        }
    }
    
    @IBInspectable
    public var maxDay: NSInteger {
        get {
            return _minDate?.day ?? 0
        }
        set {
            setMinDate(year: _maxDate?.year ?? 0, month: _maxDate?.month ?? 0, day: newValue, animated: true)
        }
    }

    @IBInspectable
    public var year: NSInteger {
        get {
            return _date?.year ?? 0
        }
        set {
            setDate(year: newValue, month: _date?.month ?? 0, day: _date?.day ?? 0, animated: true)
        }
    }

    @IBInspectable
    public var month: NSInteger {
        get {
            return _date?.month ?? 0
        }
        set {
            setDate(year: _date?.year ?? 0, month: newValue, day: _date?.day ?? 0, animated: true)
        }
    }

    @IBInspectable
    public var day: NSInteger {
        get {
            return _date?.day ?? 0
        }
        set {
            setDate(year: _date?.year ?? 0, month: _date?.month ?? 0, day: newValue, animated: true)
        }
    }
}
