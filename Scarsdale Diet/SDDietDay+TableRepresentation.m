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
    return @{@"titles":@[
                         NSLocalizedString(@"breakfast title", nil),
                         NSLocalizedString(@"lunch title", nil),
                         NSLocalizedString(@"dinner title", nil),
                         NSLocalizedString(@"replacement title", nil)
                         ],
             @"values":@[self.breakfast, self.lunch, self.dinner, self.replacement],
             @"img":self.imageName, };
}
@end
