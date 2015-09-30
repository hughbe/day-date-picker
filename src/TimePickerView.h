//
//  TimePickerView.h
//  School Planner
//
//  Created by Hugh Bellamy on 18/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView <UITableViewDataSource, UITableViewDelegate>

- (void)setup;

@property (strong, nonatomic) NSDate *minimumTime;
@property (strong, nonatomic) NSDate *time;

@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) UITableView *hourTableView;
@property (strong, nonatomic) UITableView *minuteTableView;

@property (strong, nonatomic) NSDateFormatter *hourDateFormatter;
@property (strong, nonatomic) NSDateFormatter *minuteDateFormatter;

@end
