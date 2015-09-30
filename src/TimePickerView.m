
//
//  TimePickerView.m
//  School Planner
//
//  Created by Hugh Bellamy on 18/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

#import "TimePickerView.h"
#import "UIExtensions.h"
#import "NSExtensions.h"

@interface TimePickerView ()

@property (assign, nonatomic) NSInteger rowHeight;
@property (assign, nonatomic) NSInteger centralRowOffset;

@property (strong, nonatomic) NSDateComponents *components;

@property (strong, nonatomic) UIView *overlayView;

@end

@implementation TimePickerView

@synthesize hourDateFormatter = _hourDateFormatter;
@synthesize minuteDateFormatter = _minuteDateFormatter;

- (void)setup {
    if(self.hourTableView.superview) {
        return;
    }
    
    self.rowHeight = 44;
    self.centralRowOffset = (NSInteger) ((self.frame.size.height - self.rowHeight) / 2);
    self.calendar = [NSCalendar currentCalendar];
    
    CGRect frame = self.bounds;
    frame.size.width = (CGFloat) (self.frame.size.width / 2.0);
    self.hourTableView = [self timePickerTableViewWithFrame:frame];
    [self addSubview:self.hourTableView];
    
    frame.origin.x = self.frame.size.width - frame.size.width;
    self.minuteTableView = [self timePickerTableViewWithFrame:frame];
    [self addSubview:self.minuteTableView];
        
    self.overlayView = [[UIView alloc] init];
    self.overlayView.backgroundColor = [[UIColor colorWithRed:(CGFloat) (0 / 255.0) green:(CGFloat) (153 / 255.0) blue:(CGFloat) (102 / 255.0) alpha:1.0] darkerColor];
    self.overlayView.alpha = 0.5;
    self.overlayView.userInteractionEnabled = NO;
    
    CGRect selectionViewFrame = self.bounds;
    selectionViewFrame.origin.y = self.centralRowOffset;
    selectionViewFrame.size.height = self.rowHeight;
    self.overlayView.frame = selectionViewFrame;
    
    [self addSubview:self.overlayView];
    
    [self setTime:[NSDate date] updateComponents:YES];
}

- (UITableView *)timePickerTableViewWithFrame:(CGRect)frame {
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.rowHeight = self.rowHeight;
    tableView.contentInset = UIEdgeInsetsMake(self.centralRowOffset, 0, self.centralRowOffset, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    return tableView;
}

- (void)setTime:(NSDate *)time {
    if(self.minimumTime) {
        NSDateComponents *minimumComponents = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.minimumTime];
        NSDateComponents *currentComponents = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:time];
        
        if(currentComponents.hour < minimumComponents.hour || (currentComponents.hour <= minimumComponents.hour && currentComponents.minute < minimumComponents.minute)) {
            [self setTime:[NSDate shiftDate:self.minimumTime byMinute:30] updateComponents:YES];
        }
        else {
            [self setTime:time updateComponents:YES];
        }
    }
    else {
        [self setTime:time updateComponents:YES];
    }
}

- (void)setTime:(NSDate *)time updateComponents:(BOOL)updateComponents {
    if(time) {
        NSDateComponents *components = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:time];
        CGFloat actualMinutes = components.minute - 1;
        NSInteger minute = (NSInteger) (5.0 * floor((actualMinutes / 5.0) + 0.5));
        components.minute = minute;
        components.second = 0;
        time = [self.calendar dateFromComponents:components];
    }
    _time = time;
    if(updateComponents) {
        self.components = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.time];
        [self selectRow:self.components.hour inTableView:self.hourTableView animated:YES updateComponents:NO];

        [self selectRow:self.components.minute / 5 inTableView:self.minuteTableView animated:YES updateComponents:NO];
    }
    [self reload];
}

- (void)setMinimumTime:(NSDate *)minimumTime {
    _minimumTime = minimumTime;
    self.time = self.time;
    [self reload];
}

- (void)reload {
    [self.hourTableView reloadData];
    [self.minuteTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if(tableView == self.minuteTableView) {
        numberOfRows = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMinute inUnit:NSCalendarUnitHour forDate:self.time].length / 5;
    }
    else if(tableView == self.hourTableView ) {
        numberOfRows = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitHour inUnit:NSCalendarUnitDay forDate:self.time].length;
    }
        
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    NSDateComponents *minimumComponents;
    if(self.minimumTime) {
        minimumComponents = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.minimumTime];
    }
    NSDateComponents *dateComponents = [self.components copy];
    if(tableView == self.hourTableView) {
        dateComponents.hour = indexPath.row;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        cell.textLabel.text = [self.hourDateFormatter stringFromDate:date];
        
        if(dateComponents.hour < minimumComponents.hour) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    else if(tableView == self.minuteTableView) {
        dateComponents.minute = indexPath.row * 5;
        NSDate *date = [self.calendar dateFromComponents:dateComponents];
        cell.textLabel.text = [self.minuteDateFormatter stringFromDate:date];
        
        if(dateComponents.minute < minimumComponents.minute && dateComponents.hour <= minimumComponents.hour) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self alignTableViewToRowBoundary:(UITableView *)scrollView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView {
    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
    const NSUInteger row = (NSUInteger const) round(relativeOffset.y / tableView.rowHeight);
    
    [self selectRow:row inTableView:tableView animated:YES updateComponents:YES];
}

- (void)selectRow:(NSInteger)row inTableView:(UITableView *)tableView animated:(BOOL)animated updateComponents:(BOOL)updateComponents {
    const CGPoint alignedOffset = CGPointMake(0, row * tableView.rowHeight - tableView.contentInset.top);
    [tableView setContentOffset:alignedOffset animated:animated];
    
    if(updateComponents) {
        NSDateComponents *components = [self.components copy];
        if(tableView == self.hourTableView) {
            components.hour = row;
        }
        else if(tableView == self.minuteTableView) {
            components.minute = row * 5;
        }
        components.second = 0;
        self.time = [self.calendar dateFromComponents:components];
        NSLog(@"%@", self.time);
    }
}

- (NSDateFormatter *)hourDateFormatter {
    if(!_hourDateFormatter) {
        _hourDateFormatter = [[NSDateFormatter alloc]init];
        _hourDateFormatter.dateFormat = @"H";
    }
    return _hourDateFormatter;
}

- (void)setHourDateFormatter:(NSDateFormatter *)hourDateFormatter {
    _hourDateFormatter = hourDateFormatter;
    [self.hourTableView reloadData];
}

- (NSDateFormatter *)minuteDateFormatter {
    if(!_minuteDateFormatter) {
        _minuteDateFormatter = [[NSDateFormatter alloc]init];
        _minuteDateFormatter.dateFormat = @"mm";
    }
    return _minuteDateFormatter;
}

- (void)setMinuteDateFormatter:(NSDateFormatter *)minuteDateFormatter {
    _minuteDateFormatter = minuteDateFormatter;
    [self.minuteTableView reloadData];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect frame1 = self.hourTableView.frame;
    frame1.size.height = frame.size.height;
    self.hourTableView.frame = frame1;
    
    CGRect frame2 = self.minuteTableView.frame;
    frame2.size.height = frame.size.height;
    self.minuteTableView.frame = frame2;
}

@end
