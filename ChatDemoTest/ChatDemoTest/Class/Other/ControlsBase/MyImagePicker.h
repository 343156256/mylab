//
//  TCImagePicker.h
//  SAX_iOS
//
//  Created by test on 16/4/1.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyImagePicker : NSObject

@property (nonatomic, strong, readonly) UIImagePickerController *pickerController;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, assign) BOOL allowsCustomEditing;
@property (nonatomic, assign) BOOL resizeableCropArea;
@property (nonatomic, assign) CGSize cropSize;

+ (instancetype)defaultPicker;

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
         fromController:(UIViewController *)fromController
           successBlock:(void (^)(UIImage *image))successBlock;

@end
