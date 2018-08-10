//
//  LYBridgeTestView.m
//  LYNibBridgeDemo-MacOS
//
//  Created by Lusty on 2018/7/24.
//  Copyright © 2018年 Lusty. All rights reserved.
//

#import "LYBridgeTestView.h"

@implementation LYBridgeTestView

- (void)dealloc {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0].CGColor;
}

@end
