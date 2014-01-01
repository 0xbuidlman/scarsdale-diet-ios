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
#import "SDLibraryAPI.h"

@interface SDViewController ()

@end

@implementation SDViewController

@synthesize sdCalendar, startButton, clearButton, doneButton, datePicker, dietDays, dietStart;
//@synthesize datePicker, dietStart, calendar, dietDays;


- (void)viewDidLoad
{

    sdCalendar = [self loadCalendarView];
    [[self view] addSubview:sdCalendar];
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
    self.datePicker.minimumDate = [SDHelper getDateWithOffset:-(kDietDaysPeriod - 1)];
    self.datePicker.maximumDate = [SDHelper getDateWithOffset:(kDietDaysPeriod - 1)];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setHidden:YES];
    
    [self.view addSubview:datePicker];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void) dietStartDateSelected: (id)sender {
    NSDate *selectedDate = self.datePicker.date;
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *selectedDateComponents = [currentCalendar components:[SDHelper getUnitFlags] fromDate:selectedDate];
    NSDateComponents *dietStartComponents = [[NSDateComponents alloc] init];
    
    [dietStartComponents setDay: [selectedDateComponents day]];
    [dietStartComponents setMonth: [selectedDateComponents month]];
    [dietStartComponents setYear:[selectedDateComponents year]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.dietStart = [currentCalendar dateFromComponents:dietStartComponents];
    [defaults setObject:self.dietStart forKey:@"dietStart"];
    [defaults synchronize];
    
    [datePicker setHidden:YES];
    [[SDLibraryAPI sharedInstance] setDietDaysFromStartDate:dietStart];

    [sdCalendar reloadData];
    
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




-(int)getDifferenceBetweenStartDateAndSelected:(NSDate*)selectedDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [cal components:NSDayCalendarUnit fromDate:self.dietStart toDate:selectedDate options:0];

    NSInteger difference = [comps day];
    return difference;
}
#pragma todo todo
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueSelectDietDayToShowDetails"]) {

//        NSString* key = [self getDietDayOffsetByDate:sender];
//        NSDictionary *dietDayInfo = self.dietDaysInfoDictionary[key];
//        [[segue destinationViewController] setDetailItem:dietDayInfo];        
    }
    
}

-(NSString *)getDietDayOffsetByDate:(NSDate *)theDate {
    NSInteger differenceBetweenStartDateAndSelectedDate = [self getDifferenceBetweenStartDateAndSelected:theDate];
    
    NSString *key = [NSString stringWithFormat:@"%i", (differenceBetweenStartDateAndSelectedDate % 7)];
    
    return key;
}

- (void)calendarView:(SDCalendar *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index {
    SDCalendarDietDayCell *exampleDayCell = (SDCalendarDietDayCell*)dayCell;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd MMMM y"];
    NSString* dateString = [[NSString stringWithFormat:@"%d ", index + 1] stringByAppendingString:calendarView.monthLabel.text];
    
    NSDate* date = [dateFormater dateFromString:dateString];
    if ([self isDietDay:date]) {
        self.navigationItem.rightBarButtonItem = clearButton;
        [[exampleDayCell notificationView] setHidden:NO];
    }
    
}

-(BOOL)isDietDay:(NSDate *)date
{
    if ([[SDLibraryAPI sharedInstance] isDietDay:date]) {
        
        return YES;
    }
    return NO;
}

- (void)saveCurrentState {
    [[SDLibraryAPI sharedInstance] saveDietDays];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
