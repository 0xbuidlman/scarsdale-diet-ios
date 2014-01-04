//
//  SDViewControlleriPad.m
//  Scarsdale Diet
//
//  Created by mihata on 6/7/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDViewControlleriPad.h"
//#import "SDDietDayDetailsViewController.h"

@interface SDViewControlleriPad ()

@end

@implementation SDViewControlleriPad
//- (void) clearDateTapped:(id)sender;
//{
//    [super clearDateTapped:sender];
//    self.detailsViewController.detailItem = nil;
//}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewiPad"];
//    self.detailViewController = (SDDietDayDetailsViewControlleriPad *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (CGRect) getPickerRectForSize: (CGSize) pickerSize AndScreenRect:(CGRect) screenRect {
    //    return CGRectMake(0, screenRect.origin.y + screenRect.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    return CGRectMake(0, screenRect.origin.y + screenRect.size.width - pickerSize.height, pickerSize.width, pickerSize.height);
}

- (void) calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date {
    if ([self isDietDay:date]) {
        SDDietDay *dietDayInfo = [[SDLibraryAPI sharedInstance] getDietDayByDate:date];
        self.detailViewController.detailItem = dietDayInfo;
    }
}

@end
