//
//  ViewController.h
//  DayDatePicker
//
//  Created by Hugh Bellamy on 18/01/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayDatePickerView.h"

@interface ViewController : UIViewController <DayDatePickerViewDataSource, DayDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet DayDatePickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *datePreviewLabel;

@end
