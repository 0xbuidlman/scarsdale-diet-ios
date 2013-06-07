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

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.lunchTextView.text = self.detailItem[@"lunch"];
        self.dinnerTextView.text = self.detailItem[@"dinner"];
        
        NSString *imageName = self.detailItem[@"img"];
        
        self.detailImage.image = [UIImage imageNamed:imageName];
        
        self.lunchTextView.layer.cornerRadius = kCornerRadius;
        self.dinnerTextView.layer.cornerRadius = kCornerRadius;
        self.breakfastTextView.layer.cornerRadius = kCornerRadius;
        self.replaceMealTextView.layer.cornerRadius = kCornerRadius;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureView];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:1];
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
- (IBAction)shareButton:(id)sender {
    NSString *textToShare = NSLocalizedString(@"Share Title", nil);
    UIImage *imageToShare = [UIImage imageNamed:@"114.png"];
    
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    
    if (textToShare)
        [activityItems addObject:textToShare];
    if (imageToShare)
        [activityItems addObject:imageToShare];
    
    UIActivityViewController *activityShareController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityShareController animated:YES completion:nil];

}
@end
