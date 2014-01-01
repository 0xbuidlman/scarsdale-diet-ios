//
//  SDViewControlleriPad.m
//  Scarsdale Diet
//
//  Created by mihata on 6/7/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDViewControlleriPad.h"
#import "SDDietDayDetailsViewController.h"

@interface SDViewControlleriPad ()

@end

@implementation SDViewControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
//- (void) dietStartDateSelected:(id)sender
//{
//    [super dietStartDateSelected:sender];
//    [self calendarView:self.calendar dateSelected:self.dietStart];
//}
//-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
//    
//    if ([self isDietDay:date]) {
//        NSString *key = [self getDietDayOffsetByDate:date];
//        NSDictionary *tmpItem = self.dietDaysInfoDictionary[key];
//        SDDietDayDetailsViewController *tmpDetailViewController = self.detailsViewController;
//        tmpDetailViewController.detailItem = tmpItem;
//    }
//}

- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.detailsViewController == nil) {
        self.detailsViewController = (SDDietDayDetailsViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
}

- (void) clearDateTapped:(id)sender;
{
    [super clearDateTapped:sender];
    self.detailsViewController.detailItem = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
