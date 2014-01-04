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

- (void) viewDidLoad {
    [super viewDidLoad];
    self.detailImage.image = [UIImage imageNamed:self.detailItem[@"img"]];
    CGRect frame = self.detailImage.frame;
    frame.size = CGSizeMake(self.view.frame.size.width, 256);
    self.detailImage.frame = frame;
}
@end
