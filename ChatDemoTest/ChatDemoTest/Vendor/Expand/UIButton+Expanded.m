//
//  UIButton+Expanded.m
//  Engineer_iOS
//
//  Created by plus on 15/9/29.
//  Copyright © 2015年 DF. All rights reserved.
//

#import "UIButton+Expanded.h"

@implementation UIButton (Expanded)

- (void)imageAndTitleToFitHorizonalReverse
{
    if (nil != self.titleLabel && nil != self.imageView) {
        // fix bug on iOS7
        [self sizeToFit];
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
        [self.imageView sizeToFit];
        [self.titleLabel sizeToFit];
        
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + 8, 0, -titleSize.width - 8);
    }
}

- (void)imageAndTitleToFitVerticalUp
{
    if (nil != self.titleLabel && nil != self.imageView) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize size = self.frame.size;
        CGSize titleSize = self.titleLabel.frame.size;
        CGSize imageSize = self.imageView.frame.size;
        CGFloat pad = 10 * 0.5f;
        
        // !!!: key to compatible with iOS8
        [self.titleLabel sizeToFit];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-pad, 0);
        // !!!: key to compatible with iOS8
        [self.imageView sizeToFit];
        self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-pad, (size.width - imageSize.width) * 0.5, 0, -titleSize.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, (size.width - self.titleLabel.frame.size.width) * 0.5 - imageSize.width, -imageSize.height-pad, 0);
    }
}

@end
