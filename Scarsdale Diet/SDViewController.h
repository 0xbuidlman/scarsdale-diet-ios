//
//  SDViewController.h
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCalendar.h"
#import "RDVCalendarView.h"
#import "SDLibraryAPI.h"
#import "SDDietDay+TableRepresentation.h"


@interface SDViewController : UIViewController <RDVCalendarViewDelegate>

- (void) dietStartDateSelected:(id)sender;
- (void) clearDateTapped:(id)sender;


@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) SDCalendar *sdCalendar;
@property (strong, nonatomic) NSDate *dietStart;

// navigationBar buttons
@property (strong, nonatomic) UIBarButtonItem *startButton, *clearButton, *doneButton;

- (BOOL) isDietDay: (NSDate*)date;
- (CGRect) getPickerRectForSize: (CGSize) pickerSize AndScreenRect:(CGRect) screenRect;
@end
