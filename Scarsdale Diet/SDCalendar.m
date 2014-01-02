//
//  SDCalendar.m
//  Scarsdale Diet
//
//  Created by mihata on 12/4/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDCalendar.h"

@interface SDCalendar ()
@property NSDate *firstDay;
//@property NSDateComponents *month;
@end
@implementation SDCalendar

@synthesize currentDayColor;
@synthesize selectedDayColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor* appColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:1];
        currentDayColor = appColor;

        selectedDayColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:0.8];
        
        [self.backButton setTitleColor:appColor forState:UIControlStateNormal];
        [self.forwardButton setTitleColor:appColor forState:UIControlStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
