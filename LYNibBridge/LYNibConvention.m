//
//  LYNibConvention.m
//  LYNibBridge
//
//  Created by Lusty on 2018/7/23.
//  Copyright © 2018年 LustySwimmer. All rights reserved.
//

#import <objc/runtime.h>
#import "LYNibConvention.h"

@implementation UINibBridgeView

@end

@implementation UINibBridgeView (LYNibConvention)

#pragma mark - XXNibConvention

+ (NSString *)nibid {
    NSString *className = NSStringFromClass(self);
    if ([className rangeOfString:@"."].location != NSNotFound) {
        // Swift class name contains module name
        return [className componentsSeparatedByString:@"."].lastObject;
    }
    return className;
}

+ (UINib *)nib {
#if TARGET_OS_OSX
    return [[NSNib alloc] initWithNibNamed:self.nibid bundle:nil];
#else
    return [UINib nibWithNibName:self.nibid bundle:nil];
#endif
}

#pragma mark - Public

+ (id)ly_instantiateFromNib {
    return [self ly_instantiateFromNibInBundle:nil owner:nil];
}

+ (id)ly_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner {
#if TARGET_OS_OSX
    BOOL flag = NO;
    NSArray *array = nil;
    flag = [self.nib instantiateWithOwner:nil topLevelObjects:&array];
    if (flag && array)
    {
        for (NSView *obj in array)
        {
            if ([obj isMemberOfClass:self.class])
            {
                return obj;
            }
        }
    }
    NSAssert(NO, @"Expect file: %@", [NSString stringWithFormat:@"%@.xib", self.nibid]);
    return nil;
#else
    NSArray *views = [self.nib instantiateWithOwner:owner options:nil];
    for (UIView *view in views) {
        if ([view isMemberOfClass:self.class]) {
            return view;
        }
    }
    NSAssert(NO, @"Expect file: %@", [NSString stringWithFormat:@"%@.xib", self.nibid]);
    return nil;
#endif
}

@end

@implementation UIViewController (LYNibConvention)

#pragma mark - XXNibConvention

+ (NSString *)nibid {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
#if TARGET_OS_OSX
    return [[NSNib alloc] initWithNibNamed:self.nibid bundle:nil];
#else
    return [UINib nibWithNibName:self.nibid bundle:nil];
#endif
}

#pragma mark - Public

+ (id)xx_instantiateFromStoryboardNamed:(NSString *)name {
    NSParameterAssert(name.length > 0);
#if TARGET_OS_OSX
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:name bundle:nil];
    NSAssert(storyboard != nil, @"Expect file: %@", [NSString stringWithFormat:@"%@.storyboard", name]);
    return [storyboard instantiateControllerWithIdentifier:self.nibid];
#else
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    NSAssert(storyboard != nil, @"Expect file: %@", [NSString stringWithFormat:@"%@.storyboard", name]);
    return [storyboard instantiateViewControllerWithIdentifier:self.nibid];
#endif
}

@end

@interface LYNibBridgeImplementation : UINibBridgeView
/// `NS_REPLACES_RECEIVER` attribute is a must for right ownership for `self` under ARC.
- (id)hackedAwakeAfterUsingCoder:(NSCoder *)decoder NS_REPLACES_RECEIVER;
@end

@implementation LYNibBridgeImplementation

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(awakeAfterUsingCoder:);
        SEL swizzledSelector = @selector(hackedAwakeAfterUsingCoder:);
        Method originalMethod = class_getInstanceMethod(UINibBridgeView.class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        if (class_addMethod(UINibBridgeView.class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
            class_replaceMethod(UINibBridgeView.class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        //        NSLog(@"hackedAwakeAfterUsingCoder:=====%@",[self class]);
    });
}

- (id)hackedAwakeAfterUsingCoder:(NSCoder *)decoder {
    NSLog(@"hackedAwakeAfterUsingCoder:=====%@",[self class]);
    if ([self.class conformsToProtocol:@protocol(LYNibConvention)] && ((UIView *)self).subviews.count == 0) {
        return [LYNibBridgeImplementation instantiateRealViewFromPlaceholder:(UIView *)self];
    }
    return self;
}

+ (UIView *)instantiateRealViewFromPlaceholder:(UIView *)placeholderView {
    
    // Required to conform `XXNibConvension`.
    UIView *realView = [[placeholderView class] ly_instantiateFromNib];
    
    realView.frame = placeholderView.frame;
    realView.bounds = placeholderView.bounds;
    realView.hidden = placeholderView.hidden;
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.autoresizesSubviews = placeholderView.autoresizesSubviews;
    realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
#if TARGET_OS_OSX
    realView.focusRingType = placeholderView.focusRingType;
    realView.canDrawConcurrently = placeholderView.canDrawConcurrently;
    realView.accessibilityEnabled = placeholderView.accessibilityEnabled;
    realView.appearance = placeholderView.appearance;
    [[placeholderView superview] addSubview:realView];
#else
    realView.tag = placeholderView.tag;
    realView.clipsToBounds = placeholderView.clipsToBounds;
    realView.userInteractionEnabled = placeholderView.userInteractionEnabled;
#endif
    // Copy autolayout constrains.
    if (placeholderView.constraints.count > 0) {
        
        // We only need to copy "self" constraints (like width/height constraints)
        // from placeholder to real view
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            
            NSLayoutConstraint* newConstraint;
            
            // "Height" or "Width" constraint
            // "self" as its first item, no second item
            if (!constraint.secondItem) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:nil
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            // "Aspect ratio" constraint
            // "self" as its first AND second item
            else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint =
                [NSLayoutConstraint constraintWithItem:realView
                                             attribute:constraint.firstAttribute
                                             relatedBy:constraint.relation
                                                toItem:realView
                                             attribute:constraint.secondAttribute
                                            multiplier:constraint.multiplier
                                              constant:constraint.constant];
            }
            
            // Copy properties to new constraint
            if (newConstraint) {
                newConstraint.shouldBeArchived = constraint.shouldBeArchived;
                newConstraint.priority = constraint.priority;
                newConstraint.identifier = constraint.identifier;
                [realView addConstraint:newConstraint];
            }
        }
    }
#if TARGET_OS_OSX
    //problem exists use stackView as superview,you can embed it in an empty view
    if ([[placeholderView superview] isKindOfClass:[NSStackView class]]) {
//        NSStackView *superView = (NSStackView *)[placeholderView superview];
//        [superView removeArrangedSubview:placeholderView];
        NSAssert(NO, @"can't use stackView as it's superview");
    } else {
        [placeholderView removeFromSuperview];
    }
#endif
    
    return realView;
}

@end

