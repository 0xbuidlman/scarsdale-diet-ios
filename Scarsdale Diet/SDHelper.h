//
//  SDHelper.h
//  Scarsdale Diet
//
//  Created by mihata on 1/1/14.
//  Copyright (c) 2014 Mihail Velikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDietDaysPeriod 14
#define kCornerRadius 4

@interface SDHelper : NSObject
+ (unsigned) getUnitFlags;
+ (NSDate *) getDateWithOffset:(NSInteger)offset;
@end
