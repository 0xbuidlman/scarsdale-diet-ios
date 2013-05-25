//
//  SDViewController.m
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//  init

#import "SDViewController.h"
#import "SDDietDayDetailsViewController.h"

@interface SDViewController ()
    
@end

@implementation SDViewController

//@synthesize datePicker, dietStart, calendar, dietDays;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    if (self.calendar == nil) {
        self.calendar = [[VRGCalendarView alloc] init];
        self.calendar.delegate = self;

    }
    
    [self.calendarView addSubview:self.calendar];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.dietStart = [defaults objectForKey:@"dietStart"];
    if (self.dietStart == nil) {
        [self showStartButton];
    } else {
        self.dietDays = [self settingDietDays];
        
        [self showClearButton];
    }
    
}

-(void) showStartButton
{

    UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:self action:@selector(startDate:)];
    
    self.navigationItem.rightBarButtonItem = startButton;
}
- (void) showClearButton
{
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearDate:)];
    
    
    self.navigationItem.rightBarButtonItem = clearButton;
}

-(void) showDoneButton
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dietStartDateSelected:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}


/**
 * Initialize a new datePicker with min and max date (+/- 14 days) and
 * adds it to the main view.
 */
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
    self.datePicker.minimumDate = [self getDateWithOffset:-(kDietDaysPeriod - 1)];
    self.datePicker.maximumDate = [self getDateWithOffset:(kDietDaysPeriod - 1)];
    
    [self.view addSubview:self.datePicker];

    [self showDoneButton];
}


- (void) startDate:(id)sender
{
    
    [self showDatePicker];
}

-(void) clearDate:(id)sender
{
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.dietStart = nil;
    [defaults setObject:nil forKey:@"dietStart"];
    [defaults synchronize];
    self.dietDays = nil;
    [self.calendar markDates:nil];
    
    [self showStartButton];
}

/**
 * Handles doneButton selection. Diet days is set in NSUserDefaults
 */
- (void) dietStartDateSelected:(id)sender {
    
    NSDate *selectedDate = self.datePicker.date;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:[self getUnitFlags] fromDate:selectedDate];
    
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.dietStart = [cal dateFromComponents:comps];
    [defaults setObject:selectedDate forKey:@"dietStart"];
    [defaults synchronize];
    
    [self.datePicker removeFromSuperview];
    [self.calendar markDates:[self markDietDays:self.calendar.currentMonth]];
    
    [self showClearButton];
}

// returnes flags used in NSDateComponents object
-(unsigned)getUnitFlags
{
    return NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
}

/**
 * Creates a dictionary with all diet days. The keys represent months numbers
 * and values are arrays with diet days in that month
 */
-(NSDictionary *) settingDietDays
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned unitFlags = [self getUnitFlags];
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:self.dietStart];
    NSDate *aDay;
    // initalize with dietStart date's month
    NSMutableString *monthString = [NSString stringWithFormat:@"%i", [comps month]];
    NSMutableString *monthStringKeeper = [NSMutableString stringWithString:monthString];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArray = [NSMutableArray array];

    for (int i = 0; i < 14; i++) {

        aDay = [cal dateFromComponents:comps];

        comps = [cal components:unitFlags fromDate:aDay];
        
        monthString = [NSString stringWithFormat:@"%i", [comps month]];
        
        /**
         * If diet is spread in two months new value have to be added in the
         * dictionary. <#tempArray#> is reallocated.
         * hacking :)
         */
        if (![monthStringKeeper isEqualToString:monthString]) {
            tempArray = [[NSMutableArray alloc] init];
            
            monthStringKeeper = [NSMutableString stringWithString:monthString];
        }
        [tempArray addObject:aDay];        
        [tempDict setObject:tempArray forKey:monthString];
        [comps setDay:([comps day] + 1)];
    }

    return tempDict;
}

/**
 * Once a diet start day is selected all diet days are marked on the calendar.
 */
-(NSArray *) markDietDays:(NSDate *)forGivenMonth
{
    self.dietDays = [self settingDietDays];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:[self getUnitFlags] fromDate:forGivenMonth];
    NSString *currentMonthString = [NSString stringWithFormat:@"%i", [comps month]];
    NSMutableArray *dates = [NSMutableArray array];
    
    if ([self.dietDays objectForKey:currentMonthString]) {
        
        for (id aDate in [self.dietDays objectForKey:currentMonthString]) {
            comps = [cal components:[self getUnitFlags] fromDate:aDate];

            [dates addObject:[NSNumber numberWithInt:[comps day]]];
        }
        [self.calendar markDates:dates];

    }
    
    return dates;
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

/**
 * Delegates switching months event. Used to prepopulate diet days.
 */
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    if (!self.dietDays && self.dietStart) {
        self.dietDays = [self settingDietDays];
    }
    
    NSString *currentMonthString = [NSString stringWithFormat:@"%i", month];
    
    if ([self.dietDays objectForKey:currentMonthString]) {
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps;
        NSMutableArray *dates = [NSMutableArray array];
        
        for (id aDate in [self.dietDays objectForKey:currentMonthString]) {
            comps = [cal components:[self getUnitFlags] fromDate:aDate];
            
            [dates addObject:[NSNumber numberWithInt:[comps day]]];
        }

//        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {

    if ([self isDietDay:date]) {
//        UIViewController *detailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
//        [self.navigationController pushViewController:detailsView animated:YES];
        [self performSegueWithIdentifier:@"SegueSelectDietDayToShowDetails" sender:date];
    }
//    UITabBarController *tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"TheTabBar"];
//    [self.navigationController pushViewController:tabBar animated:YES];
    
}

-(NSInteger)getDifferenceBetweenStartDateAndSelected:(NSDate*)selectedDate
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
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = _objects[indexPath.row];
        NSNumber *differenceBetweenStartDateAndSelectedDate = [NSNumber numberWithInteger:[self getDifferenceBetweenStartDateAndSelected:sender]];
        [[segue destinationViewController] setDetailItem:differenceBetweenStartDateAndSelectedDate];
    }
    NSLog(@"segue");
}

/**
 *
 */
-(BOOL)isDietDay:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:[self getUnitFlags] fromDate:date];
    
    NSString *monthString = [NSString stringWithFormat:@"%i", [comps month]];
    if ([self.dietDays objectForKey:monthString] && [self.dietDays[monthString] containsObject:date]) {
        
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
