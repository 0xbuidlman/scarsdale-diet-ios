//
//  main.m
//  Scarsdale Diet
//
//  Created by mihata on 5/22/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        id language = [userDefaults objectForKey:@"customLanguage"];
       
        if (language) {
            NSMutableArray *customAppleLanguages = [NSMutableArray arrayWithObjects:language, nil];
            NSArray *appleLanguages = [userDefaults objectForKey:@"AppleLanguages"];
            
            [customAppleLanguages addObjectsFromArray:appleLanguages];
            
            [userDefaults setObject:customAppleLanguages forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize]; //to make the change immediate
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([SDAppDelegate class]));
    }
}
