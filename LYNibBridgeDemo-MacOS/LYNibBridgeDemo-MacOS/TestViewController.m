//
//  TestViewController.m
//  LYNibBridgeDemo-MacOS
//
//  Created by Lusty on 2018/8/9.
//  Copyright © 2018年 Lusty. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (void)dealloc {
    
}

- (IBAction)dismiss:(id)sender {
//    NSApplication *application = [NSApplication sharedApplication];
//    [application stopModal];
    
    [self.presentingViewController dismissViewController:self];
}

@end
