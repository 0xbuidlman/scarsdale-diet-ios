//
//  SDDietDay.m
//  Scarsdale Diet
//
//  Created by mihata on 12/17/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDay.h"

@implementation SDDietDay

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageName forKey:@"image_name"];
    [aCoder encodeObject:self.breakfast forKey:@"breakfast"];
    [aCoder encodeObject:self.lunch forKey:@"lunch"];
    [aCoder encodeObject:self.dinner forKey:@"dinner"];
    [aCoder encodeObject:self.replacement forKey:@"replacement"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _imageName = [aDecoder decodeObjectForKey:@"image_name"];
        _breakfast = [aDecoder decodeObjectForKey:@"breakfast"];
        _dinner = [aDecoder decodeObjectForKey:@"dinner"];
        _lunch = [aDecoder decodeObjectForKey:@"lunch"];
        _replacement = [aDecoder decodeObjectForKey:@"replacement"];
    }
    
    return self;
}
@end
