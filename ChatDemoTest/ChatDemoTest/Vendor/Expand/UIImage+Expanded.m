//
//  UIImage+Expanded.m
//  Engineer_iOS
//
//  Created by plus on 15/9/24.
//  Copyright © 2015年 DF. All rights reserved.
//

#import "UIImage+Expanded.h"

@implementation UIImage (Expanded)

+ (UIImage *)imageWithContentsOfName:(NSString *)name
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

+ (UIImage *)reSizeImage:(UIImage *)image fitHeight:(CGFloat)height
{
    if (!image) {
        return nil;
    }
    CGSize size = image.size;
    CGFloat h = size.height;
    CGFloat w = size.width;
    CGFloat w1 = height * w / h;
    return [UIImage reSizeImage:image toSize:CGSizeMake(w1, height)];
}

- (UIImage *)compressImageToMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    UIImage *image = self;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

@end
