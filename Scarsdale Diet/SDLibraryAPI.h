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

- (NSArray*) getDietDays;
- (void) addDietDay:(SDDietDay*)dietDay atIndex:(int)index;
- (void) saveDietDays;
- (void) deleteDietDays;
@end
