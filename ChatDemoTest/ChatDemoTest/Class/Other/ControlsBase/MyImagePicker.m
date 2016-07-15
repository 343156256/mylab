//
//  TCImagePicker.m
//  SAX_iOS
//
//  Created by test on 16/4/1.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "MyImagePicker.h"
#import "GKImageCropViewController.h"

@interface MyImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, GKImageCropControllerDelegate>

@property (nonatomic, copy) void (^successBlock)(UIImage *);
@property (nonatomic, weak) UIViewController *fromController;

@end

@implementation MyImagePicker

+ (instancetype)defaultPicker {
    
    static dispatch_once_t onceToken;
    static MyImagePicker *picker;
    dispatch_once(&onceToken, ^{
        picker = [[MyImagePicker alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        picker.cropSize = CGSizeMake(width, (113.0f / 159.0f) * width);
        picker.allowsEditing = YES;
        picker.allowsCustomEditing = NO;
    });
    
    return picker;
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
         fromController:(UIViewController *)fromController
           successBlock:(void (^)(UIImage *image))successBlock {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return;
    }
    NSAssert(fromController != nil, @"控制器不能为空");
    NSAssert(successBlock != NULL, @"回调不能为空");
    
    self.successBlock = successBlock;
    self.fromController = fromController;
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.sourceType = sourceType;
    _pickerController.allowsEditing = self.allowsEditing;
    if (self.allowsCustomEditing) {
        _pickerController.allowsEditing = NO;
    }
    _pickerController.delegate = self;
    [self.fromController presentViewController:_pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak __typeof(&*self)weakSelf = self;
    if (self.allowsCustomEditing) {
        
        [self.fromController dismissViewControllerAnimated:YES completion:^{
            GKImageCropViewController *cropController = [[GKImageCropViewController alloc] init];
            cropController.sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            cropController.resizeableCropArea = self.resizeableCropArea;
            cropController.cropSize = self.cropSize;
            cropController.delegate = self;
            
            UINavigationController *nav = self.fromController.navigationController;
            [nav pushViewController:cropController animated:YES];
            _pickerController = nil;
        }];
    } else {
        UIImage *image = nil;
        if (self.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        void (^b)(UIImage *) = self.successBlock;
        if (b) {
            b(image);
        }
        
        [self.fromController dismissViewControllerAnimated:YES completion:^{
            weakSelf.fromController = nil;
            _pickerController = nil;
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    /// 谁present 谁dismiss
    __weak __typeof(&*self)weakSelf = self;
    [self.fromController dismissViewControllerAnimated:YES completion:^{
        weakSelf.fromController = nil;
        _pickerController = nil;
    }];
    
}

#pragma mark -
#pragma GKImageCropControllerDelegate

- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCroppedImage:(UIImage *)image {
    void (^b)(UIImage *) = self.successBlock;
    if (b) {
        b(image);
    }
    
    __weak __typeof(&*self)weakSelf = self;
    [self.fromController.navigationController popViewControllerAnimated:YES];
    weakSelf.fromController = nil;
    _pickerController = nil;
}

@end
