//
//  ViewController.m
//  LYNibBridgeDemo-MacOS
//
//  Created by Lusty on 2018/7/24.
//  Copyright © 2018年 Lusty. All rights reserved.
//

#import "ViewController.h"
#import "LYBridgeTestView.h"

@interface ViewController ()

@property (weak) IBOutlet LYBridgeTestView *testView1;
@property (weak) IBOutlet LYBridgeTestView *testView2;
@property (weak) IBOutlet LYBridgeTestView *testView3;
@property (weak) IBOutlet LYBridgeTestView *testView4;
@property (weak) IBOutlet LYBridgeTestView *testView5;
@property (weak) IBOutlet LYBridgeTestView *testView6;
@property (weak) IBOutlet LYBridgeTestView *testView7;
@property (weak) IBOutlet LYBridgeTestView *testView8;
@property (strong) NSArray <LYBridgeTestView *> *testViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.testViews = @[self.testView1, self.testView2, self.testView3, self.testView4, self.testView5, self.testView6, self.testView7, self.testView8];
//    for (LYBridgeTestView *testView in self.testViews) {
//        testView.wantsLayer = YES;
//        testView.layer.backgroundColor = [NSColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0].CGColor;
//    }
    
}

- (IBAction)modelNewWindow:(id)sender {
//    NSWindowController *windowController = [self.storyboard instantiateControllerWithIdentifier:@"TestWindowController"];
//    NSApplication *application = [NSApplication sharedApplication];
//    [application runModalForWindow:windowController.window];
//    [windowController.window close];
    
    NSViewController *viewController = [self.storyboard instantiateControllerWithIdentifier:@"TestViewController"];
    [self presentViewControllerAsModalWindow:viewController];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
