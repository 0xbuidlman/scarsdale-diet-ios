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

- (NSDictionary*) setDietDaysFromStartDate: (NSDate*)startDate {
    return [persistencyManager setDietDaysFromStartDate:startDate];
}

- (NSArray*) getDietDays {
    return [persistencyManager getDietDays];
}
- (void) addDietDay:(SDDietDay*)dietDay atIndex:(int)index {
    [persistencyManager addDietDay:dietDay atIndex:index];
}
- (void) saveDietDays {
    [persistencyManager saveDietDays];
}
- (void) deleteDietDays {
    [persistencyManager deleteDietDays];
}
@end
