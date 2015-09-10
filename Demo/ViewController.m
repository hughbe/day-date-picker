//
//  ViewController.m
//  DayDatePicker
//
//  Created by Hugh Bellamy on 18/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker.delegate = self; //1: SET DELEGATE (optional)
    self.picker.dataSource = self; //2: SET DATA SOURCE (optional)
    [self.picker setup]; //3: CALL - [DayDatePickerView setup] (NOT optional)
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.day  = 0;
    offsetComponents.month  = 0;
    offsetComponents.year  = -2;
    self.picker.minimumDate = [calendar dateByAddingComponents:offsetComponents toDate:today options:0]; //4: SET MINIMUM DATE (optional)
    //For Maximum Date
    offsetComponents.day  = 0;
    offsetComponents.month  = 0;
    offsetComponents.year  = 1;
    self.picker.maximumDate = [calendar dateByAddingComponents:offsetComponents toDate:today options:0]; //5: SET MINIMUM DATE (optional)
    //sets current date on picker
    //[self.picker setDate:[NSDate date] updateComponents:YES];
    self.picker.date = today; //6: SET DATE (NOT optional)
    
}

- (UIFont *)dayDatePickerView:(DayDatePickerView *)dayDatePickerView fontForRow:(NSInteger)row inColumn:(DayDatePickerViewColumnType)columnType disabled:(BOOL)disabled {
    UIFont *font;
    if(columnType == DayDatePickerViewColumnTypeDay) {
        font = [UIFont systemFontOfSize:18];
    }
    else if(columnType == DayDatePickerViewColumnTypeMonth) {
        font = [UIFont systemFontOfSize:16];
    }
    else if(columnType == DayDatePickerViewColumnTypeYear) {
        font = [UIFont systemFontOfSize:14];
    }
    return font;
}

- (UIColor *)dayDatePickerView:(DayDatePickerView *)dayDatePickerView textColorForRow:(NSInteger)row inColumn:(DayDatePickerViewColumnType)columnType disabled:(BOOL)disabled {
    if(disabled) {
        return [UIColor lightGrayColor];
    }
    return [UIColor purpleColor];
}

- (UIColor *)selectionViewBackgroundColorForDayDatePickerView:(DayDatePickerView *)dayDatePickerView {
    return [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:102.0/255.0 alpha:1.0];
}

- (CGFloat)selectionViewOpacityForDayDatePickerView:(DayDatePickerView *)dayDatePickerView {
    return 0.5;
}

- (void)dayDatePickerView:(DayDatePickerView *)dayDatePickerView didSelectDate:(NSDate *)date {
    self.datePreviewLabel.text = date.description;
}

@end
