//
//  SDDietDayDetailsViewController.h
//  Scarsdale Diet
//
//  Created by mihata on 5/24/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDietDayDetailsViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UITextView *lunchTextView;
@property (weak, nonatomic) IBOutlet UITextView *dinnerTextView;


@end
