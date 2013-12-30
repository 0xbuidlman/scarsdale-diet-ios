//
//  SDViewController.m
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDViewController.h"
#import "SDDietDayDetailsViewController.h"
#import "SDCalendarDietDayCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SDViewController ()

@end

@implementation SDViewController

@synthesize calendar, startButton, clearButton, doneButton, datePicker;
//@synthesize datePicker, dietStart, calendar, dietDays;


- (void)viewDidLoad
{

    calendar = [self loadCalendarView];
    [[self view] addSubview:calendar];
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL disclaimer = [defaults boolForKey:@"disclaimer"];

    if (!disclaimer) {
        NSString *disclaimerMsg = NSLocalizedString(@"disclaimer message", @"Terms and Conditions");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"disclaimer title", nil)
                message:disclaimerMsg
                delegate:self
                cancelButtonTitle:nil
                otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        
        [alertView show];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:1];
    
    startButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(startDateTapped:)];
    clearButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(clearDateTapped:)];
    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dietStartDateSelected:)];

    self.navigationItem.rightBarButtonItem = startButton;
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    
    CGRect screenRect = [self.view frame];
    CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
    CGRect pickerRect = CGRectMake(0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = pickerRect;
    self.datePicker.minimumDate = [self getDateWithOffset:-(kDietDaysPeriod - 1)];
    self.datePicker.maximumDate = [self getDateWithOffset:(kDietDaysPeriod - 1)];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setHidden:YES];
    
    [self.view addSubview:datePicker];
}

- (void) dietStartDateSelected: (id)sender {
    NSDate *selectedDate = self.datePicker.date;
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *selectedDateComponents = [currentCalendar components:[self getUnitFlags] fromDate:selectedDate];
    NSDateComponents *dietStartComponents = [[NSDateComponents alloc] init];
    
    [dietStartComponents setDay: [selectedDateComponents day]];
    [dietStartComponents setMonth: [selectedDateComponents month]];
    [dietStartComponents setYear:[selectedDateComponents year]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.dietStart = [currentCalendar dateFromComponents:dietStartComponents];
    [defaults setObject:self.dietStart forKey:@"dietStart"];
    [defaults synchronize];
    
    [datePicker setHidden:YES];
    
    self.navigationItem.rightBarButtonItem = clearButton;
}
- (void) startDateTapped:(id) sender {
    [datePicker setHidden:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void) clearDateTapped: (id) sender {
    self.navigationItem.rightBarButtonItem = startButton;
}

-(SDCalendar*)loadCalendarView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    int topCalendarPadding = 64;
    applicationFrame.origin.y = topCalendarPadding;
    applicationFrame.size.height -= topCalendarPadding;
    SDCalendar* calendarView = [[SDCalendar alloc] initWithFrame:applicationFrame];
    [calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorStyleHorizontal];
    [calendarView setBackgroundColor:[UIColor whiteColor]];
    [calendarView setDelegate:self];
    
    [calendarView registerDayCellClass:[SDCalendarDietDayCell class]];
    
    return calendarView;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL disclaimer = YES;
    [defaults setBool:disclaimer forKey:@"disclaimer"];
    [defaults synchronize];
}


// returnes flags used in NSDateComponents object
-(unsigned)getUnitFlags
{
    return NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
}

/**
 * Returns a date object that is <#offset#> days before or after today.
 * Method accepts positive and negative numbers
 */
-(NSDate *) getDateWithOffset:(NSInteger)offset
{
    NSDate *today = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:[self getUnitFlags] fromDate:today];
    
    [comps setDay:([comps day] + offset)];
    
    return [cal dateFromComponents:comps];
}

-(int)getDifferenceBetweenStartDateAndSelected:(NSDate*)selectedDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [cal components:NSDayCalendarUnit fromDate:self.dietStart toDate:selectedDate options:0];

    NSInteger difference = [comps day];
    return difference;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueSelectDietDayToShowDetails"]) {
        
        NSString* key = [self getDietDayOffsetByDate:sender];
        NSDictionary *dietDayInfo = self.dietDaysInfoDictionary[key];
        [[segue destinationViewController] setDetailItem:dietDayInfo];        
    }
    
}

-(NSString *)getDietDayOffsetByDate:(NSDate *)theDate {
    NSInteger differenceBetweenStartDateAndSelectedDate = [self getDifferenceBetweenStartDateAndSelected:theDate];
    
    NSString *key = [NSString stringWithFormat:@"%i", (differenceBetweenStartDateAndSelectedDate % 7)];
    
    return key;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
