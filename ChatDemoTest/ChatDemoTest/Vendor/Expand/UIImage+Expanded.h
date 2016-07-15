//
//  UIImage+Expanded.h
//  Engineer_iOS
//
//  Created by plus on 15/9/24.
//  Copyright © 2015年 DF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Expanded)
+ (UIImage *)imageWithContentsOfName:(NSString *)name;

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage *)reSizeImage:(UIImage *)image fitHeight:(CGFloat)height;

- (UIImage *)compressImageToMaxFileSize:(NSInteger)maxFileSize;

@end
