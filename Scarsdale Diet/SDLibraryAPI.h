//
//  SDLibraryAPI.h
//  Scarsdale Diet
//
//  Created by mihata on 12/29/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDDietDay.h"

@interface SDLibraryAPI : NSObject
+ (SDLibraryAPI*)sharedInstance;

- (NSDictionary*) getDietDays;
- (void) addDietDay:(SDDietDay*)dietDay forKey:(NSString*)key;
- (void) saveDietDays;
- (void) deleteDietDays;
- (void) setDietDaysFromStartDate: (NSDate*)startDate;
- (BOOL) isDietDay: (NSDate*) date;
@end
