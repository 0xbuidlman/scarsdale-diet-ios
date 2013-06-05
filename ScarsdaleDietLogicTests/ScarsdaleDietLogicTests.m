//
//  ScarsdaleDietLogicTests.m
//  ScarsdaleDietLogicTests
//
//  Created by mihata on 5/30/13.
//  Copyright (c) 2013 Mihail Velikov. All rights reserved.
//

#import "ScarsdaleDietLogicTests.h"


@implementation ScarsdaleDietLogicTests

- (void)setUp
{
    [super setUp];
    appDelegate = [[UIApplication sharedApplication] delegate];
    controller = [[SDViewController alloc] init];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void)testAppDelegate
{
    STAssertTrue(YES, @"yes");
}

@end
