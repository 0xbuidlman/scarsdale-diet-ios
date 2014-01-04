//
//  SDDietDayDetailsViewControlleriPad.m
//  Scarsdale Diet
//
//  Created by mihata on 6/11/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDayDetailsViewControlleriPad.h"

@interface SDDietDayDetailsViewControlleriPad ()
@property int imageHeight;
@end

@implementation SDDietDayDetailsViewControlleriPad

- (CGRect) getDetailImageFrame {
    CGRect frame = self.detailImage.frame;
    frame.size = CGSizeMake(704, 256);
    return frame;
}
@end
