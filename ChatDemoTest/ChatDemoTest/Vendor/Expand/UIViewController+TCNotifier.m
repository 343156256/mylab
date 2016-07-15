//
//  UIViewController+TCNotifier.m
//  SAX_iOS
//
//  Created by test on 16/5/5.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "UIViewController+TCNotifier.h"
#import <objc/runtime.h>
#import "TCNetworkErrorView.h"
#import "TCEmptyView.h"

@implementation UIViewController (TCNotifier)

/// ------
@dynamic blankView;

static char blankViewKey;

- (void)setBlankView:(TCNotifierBaseView *)blankView
{
    objc_setAssociatedObject(self, &blankViewKey, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)blankView
{
    return objc_getAssociatedObject(self, &blankViewKey);
}


- (TCNotifierBaseView *)showBlankViewClass:(Class)viewClass inView:(UIView *)view refreshBlock:(void (^)(void))block
{
    NSAssert([viewClass isSubclassOfClass:[TCNotifierBaseView class]] , @"must class of view or subclass of view");
    [self hideBlank];
    
    self.blankView = [[viewClass alloc] init];
    self.blankView.frame = CGRectMake(0, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    self.blankView.tapBackBlock = block;
    [view addSubview:self.blankView];
    self.blankView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.blankView.alpha = 1;
    }];
    return self.blankView;
}

- (void)hideBlank
{
    if (self.blankView != nil) {
        [self.blankView removeFromSuperview];
    }
    self.blankView = nil;
}

- (void)showNetworkErrorInView:(UIView *)view refreshBlock:(void (^)(void))block
{
    [self showBlankViewClass:[TCNetworkErrorView class] inView:view refreshBlock:block];
}

- (TCEmptyView *)showEmptyViewInView:(UIView *)view refreshBlock:(void (^)(void))block
{
   return (TCEmptyView *)[self showBlankViewClass:[TCEmptyView class] inView:view refreshBlock:block];
}

/// Dish
- (TCEmptyView *)showDishEmptyViewInView:(UIView *)view actionBlock:(void (^)(void))block
{
    TCEmptyView *emptyView = (TCEmptyView *)[self showBlankViewClass:[TCEmptyView class] inView:view refreshBlock:nil];
    emptyView.titleLabel.text = @"您还没有添加任何菜品";
    emptyView.actionButton.hidden = NO;
    emptyView.actionButtonBlock = block;
    return emptyView;
}

/// Chef
- (void)showChefEmptyView
{
    TCEmptyView *emptyView = (TCEmptyView *)[self showBlankViewClass:[TCEmptyView class] inView:self.view refreshBlock:nil];
    emptyView.titleLabel.text = @"您还没有添加厨师，请到web端添加";
    emptyView.actionButton.hidden = YES;
}

/// Chat
- (void)showChatEmptyView
{
    TCEmptyView *emptyView = (TCEmptyView *)[self showBlankViewClass:[TCEmptyView class] inView:self.view refreshBlock:nil];
//    self.blankView.frame = CGRectMake(0, -64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    emptyView.titleLabel.text = @"您不是管理员，不能和监管员聊天";
    emptyView.actionButton.hidden = YES;
}

@end
