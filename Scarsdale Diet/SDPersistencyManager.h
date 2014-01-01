//
//  SDPersistencyManager.h
//  Scarsdale Diet
//
//  Created by mihata on 12/29/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDDietDay.h"

@interface SDPersistencyManager : NSObject
- (NSDictionary*) getDietDays;
- (void) saveDietDays;
- (void) deleteDietDays;
- (void) addDietDay: (SDDietDay*)dietDay forKey:(NSString*)key;
- (NSDictionary*) setDietDaysFromStartDate: (NSDate*)startDate;
@end
