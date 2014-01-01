//
//  SDPersistencyManager.m
//  Scarsdale Diet
//
//  Created by mihata on 12/29/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#define SD_FILE_NAME @"/Documents/dietDays.bin"

#import "SDPersistencyManager.h"

@interface SDPersistencyManager() {
    NSMutableArray* dietDays;
}
@end

@implementation SDPersistencyManager

- (id)init
{

    self = [super init];

    if (self) {
        dietDays = [[NSMutableArray alloc] init];
        
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:SD_FILE_NAME]];
        dietDays = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (dietDays != nil) {
            [self saveDietDays];
        }
    }
    return self;
}

- (NSArray*)getDietDays {
    return dietDays;
}

- (void) deleteDietDays {
    [dietDays removeAllObjects];
}

- (void) addDietDay:(SDDietDay *)dietDay atIndex:(int)index {
    if (dietDays.count >= index) {
        [dietDays insertObject:dietDays atIndex:index];
    } else {
        [dietDays addObject:dietDays];
    }
}

- (NSDictionary*) setDietDaysFromStartDate: (NSDate*)startDate {
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned unitFlags = [SDHelper getUnitFlags];
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:startDate];
    NSDate *aDay;
    
    // monthString keeps current month string
    NSString *monthString = [NSString stringWithFormat:@"%i", [comps month]];
    /**
     * monthStringKeeper keeps month string for first date from diet
     * used to determine if diets 'spreads' in two months
     */
    NSString *monthStringKeeper = [NSString stringWithString:monthString];
    
    NSMutableDictionary *dietDaysDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int idx = 0; idx < kDietDaysPeriod; idx++) {
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
        [dietDaysDictionary setObject:tempArray forKey:monthString];
        [comps setDay:([comps day] + 1)];
    }
    
    return dietDaysDictionary;
}

- (void) saveDietDays {
    NSString *filename = [NSHomeDirectory() stringByAppendingString:SD_FILE_NAME];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dietDays];
    [data writeToFile:filename atomically:YES];
}
@end
