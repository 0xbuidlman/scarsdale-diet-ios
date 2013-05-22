//
//  SDViewController.m
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//  init

#import "SDViewController.h"

@interface SDViewController ()

@end

@implementation SDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate = self;
    [self.calendarView addSubview:calendar];
    
    [self showDatePicker];
    
}

- (void) showDatePicker {
    if (self.datePicker == nil) {
        self.datePicker = [[UIDatePicker alloc] init];
        
        [self.datePicker addTarget:self
                            action:nil
                  forControlEvents:UIControlEventValueChanged];
    }
    
    CGRect screenRect = [self.view frame];
    NSLog(@"Screen frame %f %f", screenRect.origin.y, screenRect.size.height);
    
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
    
    CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.frame = pickerRect;
    self.datePicker.minimumDate = [self getDateWithOffset:-kDietDaysPeriod];
    self.datePicker.maximumDate = [self getDateWithOffset:kDietDaysPeriod];
    
    [self.view addSubview:self.datePicker];
}


-(NSDate *) getDateWithOffset:(NSInteger)offset
{
    NSDate *today = [NSDate date];

    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

    NSDateComponents *comps = [cal components:unitFlags fromDate:today];
    
    [comps setDay:([comps day] + offset)];

    return [cal dateFromComponents:comps];
    
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.datePicker]){
        NSLog(@"Selected date = %@", paramDatePicker.date);
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    if (month==[[NSDate date] month]) {
        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
