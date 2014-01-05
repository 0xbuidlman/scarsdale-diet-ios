//
//  SDDietDayDetailsViewControlleriPad.h
//  Scarsdale Diet
//
//  Created by mihata on 6/11/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDayDetailsViewController.h"

@interface SDDietDayDetailsViewControlleriPad : SDDietDayDetailsViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@property (strong, nonatomic) id detailItem;

@end
