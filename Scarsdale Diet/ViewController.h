//
//  ViewController.h
//  VURIGTest
//
//  Created by mihata on 5/21/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *calendarWrapper;
- (IBAction)datePicker:(id)sender;

@end
