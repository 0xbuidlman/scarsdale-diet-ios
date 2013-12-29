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
    dietDays = [[NSMutableArray alloc] init];
    self = [super init];

    if (self) {
        
    }
    return self;
}

- (NSArray*)getDietDays {
    return dietDays;
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
