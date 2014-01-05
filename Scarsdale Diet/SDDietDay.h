//
//  SDDietDay.h
//  Scarsdale Diet
//
//  Created by mihata on 12/17/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDietDay : NSObject <NSCoding>
@property (retain, nonatomic, readonly) NSArray *imageName, *lunch, *dinner;
@property (retain, nonatomic, readonly) NSArray *breakfast, *replacement;
@property (retain, nonatomic, readonly) NSDate *date;

- (id) initWithDate: (NSDate*)date ImageName: (NSArray*)imageName breakfast:(NSArray*)breakfast lunch:(NSArray*)lunch dinner:(NSArray*)dinner andReplacement:(NSArray*)replacement;
@end
