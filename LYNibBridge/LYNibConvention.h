//
//  LYNibConvention.h
//  LYNibBridge
//
//  Created by Lusty on 2018/7/23.
//  Copyright © 2018年 LustySwimmer. All rights reserved.
//

#import "LYNibBridgeCompat.h"

@interface UINibBridgeView : UIView

@end

@protocol LYNibConvention <NSObject>

/// Class name by convention.
+ (NSString *)nibid;

/// Nib file in main bundle with class name by convention.
+ (UINib *)nib;

@end

@interface UINibBridgeView (LYNibConvention) <LYNibConvention>

/// Instantiate from `+ nib` with no owner, no options.
///
/// Required:
///   FooView.h, FooView.m, FooView.xib
/// Usage:
///   FooView *view = [FooView ly_instantiateFromNib];
///
+ (id)ly_instantiateFromNib;

/// See `+ xx_instantiateFromNib` but with bundle and owner.
+ (id)ly_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner;

@end

@interface UIViewController (XXNibConvention) <LYNibConvention>

/// Instantiate from given storyboard which class name as its `storyboard identifier`
+ (id)ly_instantiateFromStoryboardNamed:(NSString *)name;

@end


