//
//  SDPersistencyManager.m
//  Scarsdale Diet
//
//  Created by mihata on 12/29/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//



#import "SDPersistencyManager.h"

@interface SDPersistencyManager() {
    NSMutableDictionary *dietDays;
    NSDictionary *dietDaysInfoDictionary;
}
@end

@implementation SDPersistencyManager

- (id)init
{

    self = [super init];

    if (self) {
        dietDays = [[NSMutableDictionary alloc] init];
        
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:SD_FILE_NAME]];
        if (data) {
            dietDays = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"diet-info" ofType:@"plist"];
    dietDaysInfoDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return self;
}

- (NSDictionary*)getDietDays {
    return dietDays;
}

- (void) deleteDietDays {
    [dietDays removeAllObjects];
}

- (void) addDietDay:(SDDietDay *)dietDay forKey:(NSString*)key {
    [dietDays setObject:dietDays forKey:key];
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
    NSArray *breakfast = [[NSArray alloc] initWithObjects:
                          NSLocalizedString(@"breakfast1", nil),
                          NSLocalizedString(@"breakfast2", nil),
                          NSLocalizedString(@"breakfast3", nil),
                          nil];
    NSArray *replacement = [[NSArray alloc] initWithObjects:
                             NSLocalizedString(@"replacement1", nil),
                             NSLocalizedString(@"replacement2", nil),
                             NSLocalizedString(@"replacement3", nil),
                             NSLocalizedString(@"replacement4", nil),
                             NSLocalizedString(@"replacement5", nil),
                             nil];
    NSString *key;
    
    SDDietDay *aDietDay;
    
    for (int idx = 0; idx < kDietDaysPeriod; idx++) {
        key = [NSString stringWithFormat:@"%d", idx % 7];
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
        
        aDietDay = [[SDDietDay alloc] initWithDate:aDay
                     ImageName:dietDaysInfoDictionary[key][@"img"]
                     breakfast:breakfast
                         lunch:dietDaysInfoDictionary[key][@"lunch"]
                        dinner:dietDaysInfoDictionary[key][@"dinner"]
               andReplacement:replacement];
        
        [tempArray addObject:aDietDay];
        [dietDaysDictionary setObject:tempArray forKey:monthString];
        [comps setDay:([comps day] + 1)];
    }
    
    dietDays = dietDaysDictionary;
    return dietDaysDictionary;
}

- (NSString*)getMonthStringForDate: (NSDate*)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:[SDHelper getUnitFlags] fromDate:date];
    
    return [NSString stringWithFormat:@"%i", [comps month]];
    
}

- (id) getDietDayByDate: (NSDate *)date {
    
    NSString *monthString = [self getMonthStringForDate:date];
    for (SDDietDay *idx in dietDays[monthString]) {
        if ([idx.date compare:date] == NSOrderedSame) {
            return idx;
        }
    }
    return NO;
}
- (BOOL) isDietDay: (NSDate*) date {
    NSString *monthString = [self getMonthStringForDate:date];
    BOOL flag = NO;

    if ([dietDays objectForKey:monthString]) {
        for (SDDietDay *idx in dietDays[monthString]) {
            if ([idx.date compare:date] == NSOrderedSame) {
                flag = YES;
                break;
            }
        }
    }
    return flag;
}


- (void) saveDietDays {
    NSString *filename = [NSHomeDirectory() stringByAppendingString:SD_FILE_NAME];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dietDays];
    [data writeToFile:filename atomically:YES];
}
@end
