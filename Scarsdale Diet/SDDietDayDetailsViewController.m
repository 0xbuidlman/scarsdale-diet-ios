//
//  SDDietDayDetailsViewController.m
//  Scarsdale Diet
//
//  Created by mihata on 5/24/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDayDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface SDDietDayDetailsViewController ()

@end

@implementation SDDietDayDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.lunchTextView.text = self.detailItem[@"lunch"];
    self.dinnerTextView.text = self.detailItem[@"dinner"];
    
    NSString *imageName = self.detailItem[@"img"];
    
    self.detailImage.image = [UIImage imageNamed:imageName];
    
    self.lunchTextView.layer.cornerRadius = kCornerRadius;
    self.dinnerTextView.layer.cornerRadius = kCornerRadius;
    self.breakfastTextView.layer.cornerRadius = kCornerRadius;
    self.replaceMealTextView.layer.cornerRadius = kCornerRadius;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLunchTextView:nil];
    [self setDinnerTextView:nil];
    [self setBreakfastTextView:nil];
    [self setReplaceMealTextView:nil];
    [super viewDidUnload];
}
@end
