//
//  SDHelper.m
//  Scarsdale Diet
//
//  Created by mihata on 1/1/14.
//  Copyright (c) 2014 Mihail Velikov. All rights reserved.
//

#import "SDHelper.h"

@implementation SDHelper

// returnes flags used in NSDateComponents object
+ (unsigned) getUnitFlags
{
    return NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
}


/**
 * Returns a date object that is <#offset#> days before or after today.
 * Method accepts positive and negative numbers
 */
+ (NSDate*) getDateWithOffset:(NSInteger)offset
{
    NSDate *today = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:[self getUnitFlags] fromDate:today];
    
    [comps setDay:([comps day] + offset)];
    
    return [cal dateFromComponents:comps];
}
@end
