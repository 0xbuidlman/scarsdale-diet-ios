//
//  SDDietDay+TableRepresentation.m
//  Scarsdale Diet
//
//  Created by mihata on 1/1/14.
//  Copyright (c) 2014 Mihail Velikov. All rights reserved.
//

#import "SDDietDay+TableRepresentation.h"

@implementation SDDietDay (TableRepresentation)
- (NSDictionary*)tr_tableRepresentation
{
    return @{@"titles":@[NSLocalizedString(@"breakfast", nil),
                         NSLocalizedString(@"lunch", nil),
                         NSLocalizedString(@"dinner", nil),
                         NSLocalizedString(@"replacement", nil),
                         @"img"],
             @"values":@[self.breakfast, self.lunch, self.dinner, self.replacement, self.imageName]};
}
@end
