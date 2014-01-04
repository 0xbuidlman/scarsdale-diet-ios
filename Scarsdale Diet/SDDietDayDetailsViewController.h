//
//  SDDietDayDetailsViewController.h
//  Scarsdale Diet
//
//  Created by mihata on 5/24/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SDDietDayDetailsViewController : UITableViewController <UITableViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@property (strong, nonatomic) id detailItem;

- (IBAction)shareButton:(id)sender;

- (CGRect) getDetailImageFrame;
- (void)setDetailItem:(id)newDetailItem;

@end
