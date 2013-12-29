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

- (void) saveDietDays {
    NSString *filename = [NSHomeDirectory() stringByAppendingString:SD_FILE_NAME];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dietDays];
    [data writeToFile:filename atomically:YES];
}
@end
