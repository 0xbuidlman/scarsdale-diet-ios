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

@synthesize sdCalendar, startButton, clearButton, doneButton, datePicker, dietStart;

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
    
    dietStart = [defaults objectForKey:@"dietStart"];
    
    if (dietStart) {
        [[SDLibraryAPI sharedInstance] setDietDaysFromStartDate:dietStart];
        [sdCalendar reloadData];
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
    CGRect pickerRect = [self getPickerRectForSize:pickerSize AndScreenRect:screenRect];
    
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
    
    dietStart = [currentCalendar dateFromComponents:dietStartComponents];
    [defaults setObject:dietStart forKey:@"dietStart"];
    [defaults synchronize];
    
    [datePicker setHidden:YES];
    [[SDLibraryAPI sharedInstance] setDietDaysFromStartDate:dietStart];

    [sdCalendar reloadData];
    
    [self saveCurrentState];
    
    self.navigationItem.rightBarButtonItem = clearButton;
}
- (void) startDateTapped:(id) sender {
    [datePicker setHidden:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void) clearDateTapped: (id) sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"dietStart"];
    [defaults synchronize];
    dietStart = nil;
    [[SDLibraryAPI sharedInstance] deleteDietDays];
    self.navigationItem.rightBarButtonItem = startButton;
    
    [sdCalendar reloadData];

}

-(SDCalendar*)loadCalendarView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    applicationFrame.origin.y = kTopCalendarPadding;
    applicationFrame.origin.x = 0;
    applicationFrame.size.height -= kTopCalendarPadding;
    applicationFrame.size.width = self.view.frame.size.width;
    SDCalendar* calendarView = [[SDCalendar alloc] initWithFrame:applicationFrame];
    [calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorStyleHorizontal];
    [calendarView setBackgroundColor:[UIColor whiteColor]];
    [calendarView setDelegate:self];
    
    [calendarView registerDayCellClass:[SDCalendarDietDayCell class]];
    
    return calendarView;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL disclaimer = YES;
    [defaults setBool:disclaimer forKey:@"disclaimer"];
    [defaults synchronize];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SegueSelectDietDayToShowDetails"]) {
        SDDietDay *dietDayInfo = [[SDLibraryAPI sharedInstance] getDietDayByDate:sender];
        [[segue destinationViewController] setDetailItem:[dietDayInfo tr_tableRepresentation]];
    }
}

- (void) calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date {
    if ([self isDietDay:date]) {
        [self performSegueWithIdentifier:@"SegueSelectDietDayToShowDetails" sender:date];
    }
}

- (void) calendarView: (SDCalendar *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
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

- (BOOL) isDietDay: (NSDate*)date
{
    return [[SDLibraryAPI sharedInstance] isDietDay:date];
}

- (void)saveCurrentState {
    [[SDLibraryAPI sharedInstance] saveDietDays];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) getPickerRectForSize: (CGSize) pickerSize AndScreenRect:(CGRect) screenRect {
    return CGRectMake(0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
