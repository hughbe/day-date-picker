//
//  ViewController.m
//  DayDatePicker
//
//  Created by Hugh Bellamy on 18/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//
//  Modified by Robert Miller on 10/09/2015
//  Copyright (c) 2015 Robert Miller. All rights reserved.

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) DayDatePickerView *datePicker;

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
    self.picker.date = today; //6: SET DATE (NOT optional)
  
    //create date picker
    _datePicker = [[DayDatePickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), pickerHeight)];
    _datePicker.alpha = 0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _datePicker.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)-CGRectGetWidth([UIScreen mainScreen].bounds))/2, -CGRectGetHeight(_datePicker.frame), CGRectGetWidth(_datePicker.frame), pickerHeight);
    _datePicker.toFrame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)-CGRectGetWidth([UIScreen mainScreen].bounds))/2, (CGRectGetHeight([UIScreen mainScreen].bounds)-CGRectGetHeight(_datePicker.frame))/2, CGRectGetWidth(_datePicker.frame), pickerHeight);
    _datePicker.originalFrame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)-CGRectGetWidth([UIScreen mainScreen].bounds))/2, -CGRectGetHeight(_datePicker.frame), CGRectGetWidth(_datePicker.frame), pickerHeight);
    CALayer *caLayer = _datePicker.layer;
    caLayer.frame = _datePicker.frame;
    caLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    caLayer.shadowRadius = 3.0;
    caLayer.shadowOpacity = 0.4;
    caLayer.shadowOffset = CGSizeMake(0.0, 3.0);
    caLayer.shouldRasterize = true;
    caLayer.rasterizationScale = [UIScreen mainScreen].scale;
    caLayer.shouldRasterize = true;
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

- (IBAction)alertStyleButton:(id)sender
{
    if (_datePicker.showing)
    {
        [_datePicker dismiss];
    }
    else
    {
        [_datePicker showInView:self.topView];
    }
}

@end
