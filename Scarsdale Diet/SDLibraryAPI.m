//
//  SDLibraryAPI.m
//  Scarsdale Diet
//
//  Created by mihata on 12/29/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDLibraryAPI.h"
#import "SDPersistencyManager.h"

@interface SDLibraryAPI() {
    SDPersistencyManager *persistencyManager;
}

@end

@implementation SDLibraryAPI

- (id) init {
    self = [super init];
    
    if (self) {
        persistencyManager = [[SDPersistencyManager alloc] init];
    }
    
    return self;
}
+ (SDLibraryAPI*)sharedInstance {
    static SDLibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SDLibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (id) getDietDayByDate: (NSDate *)date {
    return [persistencyManager getDietDayByDate:date];
}
- (void) setDietDaysFromStartDate: (NSDate*)startDate {
    [persistencyManager setDietDaysFromStartDate:startDate];
}

- (BOOL) isDietDay: (NSDate*) date {
    return [persistencyManager isDietDay:date];
}

- (NSDictionary*) getDietDays {
    return [persistencyManager getDietDays];
}
- (void) addDietDay:(SDDietDay*)dietDay forKey:(NSString *)key {
    [persistencyManager addDietDay:dietDay forKey:key];
}
- (void) saveDietDays {
    [persistencyManager saveDietDays];
}
- (void) deleteDietDays {
    [persistencyManager deleteDietDays];
}
@end
