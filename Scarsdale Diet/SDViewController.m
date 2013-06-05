//
//  SDViewController.m
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDViewController.h"
#import "SDDietDayDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SDViewController ()
@property (strong, nonatomic) NSDictionary *dietDaysInfoDictionary;
@end

@implementation SDViewController

//@synthesize datePicker, dietStart, calendar, dietDays;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self setRoundedCournersForNavigationController];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:1];
    
    if (self.calendar == nil) {
        self.calendar = [[VRGCalendarView alloc] init];
        self.calendar.delegate = self;

    }
    
    [self.calendarView addSubview:self.calendar];

    if (!self.dietDaysInfoDictionary) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"diet-info" ofType:@"plist"];
        self.dietDaysInfoDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }

    
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.dietStart = [defaults objectForKey:@"dietStart"];
    
    if (self.dietStart == nil) {
        [self showStartButton];
    } else {
        if (!self.dietDays)
            self.dietDays = [self settingDietDays];
        
        [self showClearButton];
    }
    
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

}

-(void) setRoundedCournersForNavigationController
{
    CALayer *capa = [self.navigationController navigationBar].layer;
    [capa setShadowColor: [[UIColor blackColor] CGColor]];
    [capa setShadowOpacity:0.85f];
    [capa setShadowOffset: CGSizeMake(0.0f, 1.5f)];
    [capa setShadowRadius:2.0f];
    [capa setShouldRasterize:YES];
    
    
    //Round
    CGRect bounds = capa.bounds;
    bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
}
-(void) showStartButton
{

    UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(startDate:)];
    
    self.navigationItem.rightBarButtonItem = startButton;
}
- (void) showClearButton
{
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(clearDate:)];
    
    
    self.navigationItem.rightBarButtonItem = clearButton;
}

-(void) showDoneButton
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(dietStartDateSelected:)];
    
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
    
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
    
    CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.frame = pickerRect;
    self.datePicker.minimumDate = [self getDateWithOffset:-(kDietDaysPeriod - 1)];
    self.datePicker.maximumDate = [self getDateWithOffset:(kDietDaysPeriod - 1)];
    
    [self.view addSubview:self.datePicker];

    [self showDoneButton];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL disclaimer = YES;
    [defaults setBool:disclaimer forKey:@"disclaimer"];
    [defaults synchronize];
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
    if (!self.dietDays)
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

        [self performSegueWithIdentifier:@"SegueSelectDietDayToShowDetails" sender:date];
    } else {
//        [self performSegueWithIdentifier:@"SegueSelectDietDayTest" sender:self];
    }
    
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
        
        NSInteger differenceBetweenStartDateAndSelectedDate = [self getDifferenceBetweenStartDateAndSelected:sender];
        
        NSString *key = [NSString stringWithFormat:@"%i", (differenceBetweenStartDateAndSelectedDate % 7)];
        NSDictionary *dietDayInfo = self.dietDaysInfoDictionary[key];
        [[segue destinationViewController] setDetailItem:dietDayInfo];
        
    } else if ([[segue identifier] isEqualToString:@"SegueSelectDietDayTest"]) {
        
    }
    
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
