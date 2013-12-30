//
//  SDCalendarDietDayCell.m
//  Scarsdale Diet
//
//  Created by mihata on 12/4/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "SDCalendarDietDayCell.h"

@implementation SDCalendarDietDayCell
@synthesize notificationView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor* appColor = [UIColor colorWithRed:11/255.0f green:140/255.0f blue:5/255.0f alpha:1];
        notificationView = [[UIView alloc] init];
        [notificationView setBackgroundColor:appColor];
        [notificationView setHidden:YES];
        
        [self.contentView addSubview:notificationView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize viewSize = self.contentView.frame.size;

    [notificationView setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    notificationView.alpha = 0.5;
    notificationView.layer.cornerRadius = 23;
    
    
}

- (void)prepareForReuse {
    [[self notificationView] setHidden:YES];
}

- (void)setSelected:(BOOL)selected {
    self.layer.cornerRadius = 23;

    [super setSelected:selected];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
