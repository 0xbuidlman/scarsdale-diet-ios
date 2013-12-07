//
//  SDViewController.h
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VRGCalendarView.h"
#import "SDCalendar.h"
#import "RDVCalendarView.h"
#define kDietDaysPeriod 14

@class SDDietDayDetailsViewController;

@interface SDViewController : UIViewController <RDVCalendarViewDelegate>

- (void) dietStartDateSelected:(id)sender;
-(void) clearDate:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *calendarView;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) SDCalendar *calendar;

@property (strong, nonatomic) NSDate *dietStart;
@property (strong, nonatomic) NSDictionary *dietDays;

@property (strong, nonatomic) NSDictionary *dietDaysInfoDictionary;

@property (strong, nonatomic) SDDietDayDetailsViewController *detailsViewController;


-(BOOL)isDietDay:(NSDate *)date;
//-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date;
-(NSString *)getDietDayOffsetByDate:(NSDate *)theDate;
@end
