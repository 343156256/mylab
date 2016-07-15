//
//  UINavigationBar+TCBackgroundColor.m
//  SAX_iOS
//
//  Created by 普拉斯 on 16/5/4.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "UINavigationBar+TCBackgroundColor.h"
#import <objc/runtime.h>
#import "UIImage+CGImage.h"

@implementation UINavigationBar (TCBackgroundColor)
//
//static char overlayKey;
//
//- (UIView *)overlay
//{    return objc_getAssociatedObject(self, &overlayKey);
//}
//
//- (void)setOverlay:(UIView *)overlay
//{
//    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)tc_setBackgroundColor:(UIColor *)backgroundColor
{
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
//    if (!self.overlay) {
//        [self setBackgroundImage:[UIImage imageWithColor:backgroundColor size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self setShadowImage:[UIImage new]];        // insert an overlay into the view hierarchy
//        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
//        [self insertSubview:self.overlay atIndex:0];
//    }    self.overlay.backgroundColor = backgroundColor;
}

@end
