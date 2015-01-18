//
//  DayDatePickerView.h
//  DayDatePicker
//
//  Created by Hugh Bellamy on 17/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DayDatePickerViewDelegate;
@protocol DayDatePickerViewDataSource;

typedef NS_ENUM(NSInteger, DayDatePickerViewColumnType) {
    DayDatePickerViewColumnTypeDay,
    DayDatePickerViewColumnTypeMonth,
    DayDatePickerViewColumnTypeYear
};

@interface DayDatePickerView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (void)reload;

@property (weak, nonatomic) id<DayDatePickerViewDelegate> delegate;
@property (weak, nonatomic) id<DayDatePickerViewDataSource> dataSource;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSDateFormatter *dayDateFormatter;
@property (strong, nonatomic) NSDateFormatter *monthDateFormatter;
@property (strong, nonatomic) NSDateFormatter *yearDateFormatter;

@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) UITableView *daysTableView;
@property (strong, nonatomic) UITableView *monthsTableView;
@property (strong, nonatomic) UITableView *yearsTableView;

@end

@protocol DayDatePickerViewDataSource <NSObject>

@optional
- (NSInteger)numberOfYearsInDayDatePickerView:(DayDatePickerView *)dayDatePickerView;

@end

@protocol DayDatePickerViewDelegate <NSObject>

@optional
- (void)dayDatePickerView:(DayDatePickerView *)dayDatePickerView didSelectDate:(NSDate *)date;

- (CGFloat)dayDatePickerView:(DayDatePickerView *)dayDatePickerView sizeFractionForColumnType:(DayDatePickerViewColumnType)columnType;
- (CGFloat)rowHeightForDayDatePickerView:(DayDatePickerView *)dayDatePickerView;

- (UIFont *)dayDatePickerView:(DayDatePickerView *)dayDatePickerView fontForRow:(NSInteger)row inColumn:(DayDatePickerViewColumnType)columnType disabled:(BOOL)disabled;
- (UIColor *)dayDatePickerView:(DayDatePickerView *)dayDatePickerView textColorForRow:(NSInteger)row inColumn:(DayDatePickerViewColumnType)columnType disabled:(BOOL)disabled;

- (UIColor *)dayDatePickerView:(DayDatePickerView *)dayDatePickerView backgroundColorForColumn:(DayDatePickerViewColumnType)columnType;
- (UIColor *)dayDatePickerView:(DayDatePickerView *)dayDatePickerView backgroundColorForRow:(NSInteger)row inColumn:(DayDatePickerViewColumnType)columnType;

- (UIView *)selectionViewForDayDatePickerView:(DayDatePickerView *)dayDatePickerView;
- (UIColor *)selectionViewBackgroundColorForDayDatePickerView:(DayDatePickerView *)dayDatePickerView;
- (CGFloat)selectionViewOpacityForDayDatePickerView:(DayDatePickerView *)dayDatePickerView;

@end
