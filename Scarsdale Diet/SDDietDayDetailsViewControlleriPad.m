//
//  SDDietDayDetailsViewControlleriPad.m
//  Scarsdale Diet
//
//  Created by mihata on 6/11/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDayDetailsViewControlleriPad.h"

@interface SDDietDayDetailsViewControlleriPad ()

@end

@implementation SDDietDayDetailsViewControlleriPad

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
    
}

-(void)configureView
{
    if (self.detailItem == nil) {
        [self.scrollView setHidden:YES];
        [self.tipLabelView setHidden:NO];
    } else {
        [self.tipLabelView setHidden:YES];
        [self.scrollView setHidden:NO];
    }
    
//    [super configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
