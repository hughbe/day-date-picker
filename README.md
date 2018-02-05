# DayDatePicker
A custom and customizable UIDatePicker which displays the day of the week alongside the day column

## Screenshots
![Screenshot 1](https://github.com/hughbe/DayDatePicker/blob/master/resources/screenshots/1.png "Screenshot 1")
![Screenshot 2](https://github.com/hughbe/DayDatePicker/blob/master/resources/screenshots/2.png "Screenshot 2")

## Installation

DayDatePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DayDatePicker'
```

## Usage
From interface builder, create a UIView and set the class to `TimePickerView` or `DayDatePickerView`. The display will render in interface builder. These views use Auto Layout. Use the `editingChanged` event to receive updates when the date/time was changed.

DayDatePickerView is highly customizable, making is an ideal replacement for UIDatePicker if working with dates only. You can implement DayDatePickerViewDelegate or TimePickerViewDelegate to customize the display of cells in each column.

Use the `overlayView` property to access or modify the selection indicator.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
