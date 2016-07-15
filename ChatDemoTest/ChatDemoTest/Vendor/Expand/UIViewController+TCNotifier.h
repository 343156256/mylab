//
//  UIViewController+TCNotifier.h
//  SAX_iOS
//
//  Created by test on 16/5/5.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCNotifierBaseView.h"

@interface UIViewController (TCNotifier)

@property (nonatomic, strong) TCNotifierBaseView *blankView;
- (TCNotifierBaseView *)showBlankViewClass:(Class)viewClass inView:(UIView *)view refreshBlock:(void (^)(void))block;
- (void)hideBlank;

/// 添加在指定view上
- (void)showNetworkErrorInView:(UIView *)view refreshBlock:(void (^)(void))block;

// 无数据页面
- (TCEmptyView *)showEmptyViewInView:(UIView *)view refreshBlock:(void (^)(void))block;

/// Dish
- (TCEmptyView *)showDishEmptyViewInView:(UIView *)view actionBlock:(void (^)(void))block;

/// Chef
- (void)showChefEmptyView;

/// Chat
- (void)showChatEmptyView;

@end
