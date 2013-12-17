//
//  SDDietDay.h
//  Scarsdale Diet
//
//  Created by mihata on 12/17/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDietDay : NSObject {
    NSString* imageName;
    NSString* breakfast;
    NSString* lunch;
    NSString* dinner;
    NSString* replacement;
}
@property (retain, nonatomic) NSString* imageName;
@property (retain, nonatomic) NSString* breakfast;
@property (retain, nonatomic) NSString* lunch;
@property (retain, nonatomic) NSString* dinner;
@property (retain, nonatomic) NSString* replacement;
@end
