//
//  WinterSegmentControlView.h
//  FoxLife
//
//  Created by WinterChen on 15/8/6.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MySegmentControlViewDelegate <NSObject>

@optional
- (void)segmentControlDidSelected:(NSInteger)selectedIndex;

@end

@interface MySegmentControlView : UISegmentedControl
{
    UISegmentedControl *_segmentControl;
}

@property (nonatomic, weak) id<MySegmentControlViewDelegate> delegate;

// 实例化对象
- (id)initWithSegmentControlItems:(NSArray *)items defaultSelectedIndex:(NSInteger)selectedIndex;

// 设置字号
- (void)setupSegmentControlTitleFont:(CGFloat)font;

@end
