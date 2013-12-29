//
//  SDDietDay.h
//  Scarsdale Diet
//
//  Created by mihata on 12/17/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDietDay : NSObject <NSCoding>
@property (retain, nonatomic, readonly) NSString *imageName, *breakfast, *lunch, *dinner, *replacement;
@end
