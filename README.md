# DayDatePicker
A custom and customizable UIDatePicker which displays the day of the week alongside the day column

Screenshots
--------------
![alt text](https://github.com//hughbe/Day-Date-Picker/blob/master/Screenshot1.png "Screenshot 1")
![alt text](https://github.com//hughbe/Day-Date-Picker/blob/master/Screenshot2.png "Screenshot 2")

How to setup
--------------
- 1: Create picker
    picker = [[DayDatePickerView alloc]initWithFrame:frame];
- 2: Set delegate and data source (optional)
    picker.delegate assd
- 4: Set date and minimum date (optional)
    picker.date = [NSDate date];
    picker.minimumDate = [NSDate date];

Delegate and Data Source
--------------
DayDatePickerView is almost entirely customizable, making is an ideal replacement for UIDatePicker if working with dates only
You can:

- Change the selection indicator: change opacity, background color or even the whole view itself
- Change the way columns are displayed: width and background color
- Change the way rows are displayed: foreground color, disabled color, background color and font
- Change the UIDateFormatters (day, month and year) to suit your liking
- Recieve updates when the date is changed
