//
//  SDDietDayDetailsViewController.m
//  Scarsdale Diet
//
//  Created by mihata on 5/24/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDDietDayDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VRGCalendarView.h"


@interface SDDietDayDetailsViewController ()
@property (retain, nonatomic) NSMutableDictionary* cellHeightHolder;
@end

@implementation SDDietDayDetailsViewController
@synthesize detailImage;

- (id) init {
    self = [super init];
    if (self)
        _cellHeightHolder = [[NSMutableDictionary alloc] init];
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
//        [self configureView];
    }
}
/*
- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.lunchTextView.text = self.detailItem[@"values"][1];
        self.dinnerTextView.text = self.detailItem[@"values"][2];
        self.breakfastTextView.text = self.detailItem[@"values"][0];
        self.replaceMealTextView.text = self.detailItem[@"values"][3];
        NSString *imageName = self.detailItem[@"values"][4];
        
        self.detailImage.image = [UIImage imageNamed:imageName];
        
    }

    self.lunchTextView.layer.cornerRadius = kCornerRadius;
    self.dinnerTextView.layer.cornerRadius = kCornerRadius;
    self.breakfastTextView.layer.cornerRadius = kCornerRadius;
    self.replaceMealTextView.layer.cornerRadius = kCornerRadius;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [self configureView];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:1];
    detailImage.image = [UIImage imageNamed:_detailItem[@"img"]];


    self.tableView.delegate = self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _detailItem[@"titles"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }

    [cell.textLabel setText:_detailItem[@"values"][indexPath.section]];
    [cell.textLabel sizeToFit];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setNumberOfLines:0];
    [cell setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];

    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setTextAlignment: NSTextAlignmentJustified];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [label setNumberOfLines:0];
    
    [label setText:_detailItem[@"values"][indexPath.section]];
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setTextAlignment:NSTextAlignmentJustified];

    [label sizeToFit];

    return label.frame.size.height;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)viewDidUnload {
    [self setLunchTextView:nil];
    [self setDinnerTextView:nil];
    [self setBreakfastTextView:nil];
    [self setReplaceMealTextView:nil];
    [super viewDidUnload];
}
*/
- (IBAction)shareButton:(id)sender {
    NSString *textToShare = NSLocalizedString(@"Share Title", nil);
    UIImage *imageToShare = [UIImage imageNamed:@"144.png"];
    
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    
    if (textToShare)
        [activityItems addObject:textToShare];
    if (imageToShare)
        [activityItems addObject:imageToShare];
    
    UIActivityViewController *activityShareController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityShareController animated:YES completion:nil];

}
@end
