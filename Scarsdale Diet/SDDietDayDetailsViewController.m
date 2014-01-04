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

@end

@implementation SDDietDayDetailsViewController
@synthesize detailImage;

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
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10/255.0f green:145/255.0f blue:5/255.0f alpha:1];
    if (_detailItem)
        detailImage.image = [UIImage imageNamed:_detailItem[@"img"]];
    
    detailImage.frame = [self getDetailImageFrame];

    self.tableView.delegate = self;
}

- (CGRect) getDetailImageFrame {
    CGRect frame = detailImage.frame;
    frame.size = CGSizeMake(self.view.frame.size.width, 240);
    return frame;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return [_detailItem[@"values"][section] count];
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

    [cell.textLabel setText:_detailItem[@"values"][indexPath.section][indexPath.row]];
    
    [cell.textLabel sizeToFit];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];

    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setTextAlignment: NSTextAlignmentJustified];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    NSString *text = _detailItem[@"values"][indexPath.section][indexPath.row];
    [label setNumberOfLines:0];
    [label setText:text];
    [label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setTextAlignment:NSTextAlignmentJustified];
    
    [label sizeToFit];
    
    CGFloat height = label.frame.size.height;
    if (height <= 44) {
        height = 44.0;
    }
    return height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
