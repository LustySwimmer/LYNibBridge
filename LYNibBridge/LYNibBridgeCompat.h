//
//  LYNibBridgeCompat.h
//  LYNibBridge
//
//  Created by Lusty on 2018/7/23.
//  Copyright © 2018年 LustySwimmer. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_OSX

#import <AppKit/AppKit.h>
#ifndef UIView
#define UIView NSView
#endif

#ifndef UINib
#define UINib NSNib
#endif

#ifndef UIViewController
#define UIViewController NSViewController
#endif

#else

#import <UIKit/UIKit.h>

#endif
