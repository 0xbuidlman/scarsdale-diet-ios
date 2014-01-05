//
//  SDDietDayDetailsViewControlleriPad.m
//  Scarsdale Diet
//
//  Created by mihata on 6/11/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDayDetailsViewControlleriPad.h"

@interface SDDietDayDetailsViewControlleriPad ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation SDDietDayDetailsViewControlleriPad

- (void) viewDidLoad {
    [super viewDidLoad];
}
- (void)setDetailItem:(id)newDetailItem {
    [super setDetailItem:newDetailItem];
    [self.tableView reloadData];
    self.detailImage.image = [UIImage imageNamed:newDetailItem[@"img"]];
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}
- (CGRect) getDetailImageFrame {
    CGRect frame = self.detailImage.frame;
    frame.size = CGSizeMake(704, 256);
    return frame;
}
@end
