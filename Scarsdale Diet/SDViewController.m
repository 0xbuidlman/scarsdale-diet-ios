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

@synthesize datePicker, doneButton, navigationItem, dietStart, calendar, dietDays;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

    self.dietStart = [defaults objectForKey:@"dietStart"];
    
    if (self.navigationItem == nil) {
        self.navigationItem = [[UINavigationItem alloc] initWithTitle:@"Scarsdale Diet"];
    }
    
    if (self.calendar == nil) {
        self.calendar = [[VRGCalendarView alloc] init];
        self.calendar.delegate = self;

    }
    
    [self.calendarView addSubview:self.calendar];
    
    if (self.dietStart == nil) {
        [self showDatePicker];
    }
    
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];
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

    [self showDoneButton];
}

-(void) showDoneButton
{
    if (self.doneButton == nil) {
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dateSelected:)];
    }
    
    self.navigationItem.rightBarButtonItem = self.doneButton;

}

- (void) dateSelected:(id)sender {
    self.navigationItem.rightBarButtonItem = nil;
    
    NSDate *selectedDate = self.datePicker.date;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.dietStart = selectedDate;
    [defaults setObject:selectedDate forKey:@"dietStart"];
    [defaults synchronize];
    
    [self.datePicker removeFromSuperview];
    [self markDietDays];
}

-(void) settingDietDays
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:self.dietStart];
    NSDate *aDay;
    for (int i = 0; i < 14; i++) {
        [comps setDay:([comps day] + 1)];
        aDay = [cal dateFromComponents:comps];
        
        [self.dietDays setObject:aDay forKey:[NSString stringWithFormat:@"%i", [comps month]]];
    }

}

-(void) markDietDays
{
    [self settingDietDays];
    NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:6], nil];
    [self.calendar markDates:dates];
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
