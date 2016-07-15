//
//  WinterSegmentControlView.m
//  FoxLife
//
//  Created by WinterChen on 15/8/6.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MySegmentControlView.h"

@implementation MySegmentControlView

- (id)initWithSegmentControlItems:(NSArray *)items defaultSelectedIndex:(NSInteger)selectedIndex
{
    if (self = [super initWithItems:items]) {
        self.frame = CGRectMake(0, 0,150, 24);
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 2, 21);
        self.selectedSegmentIndex = selectedIndex;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;

        [self setBackgroundImage:[UIImage imageNamed:@"nav_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        NSDictionary * selectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background"]]};
        [self setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
        NSDictionary * unselectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self setTitleTextAttributes:unselectedTextAttr forState:UIControlStateNormal];
        
        [self addTarget:self action:@selector(selectTheTouchedIndex:) forControlEvents:UIControlEventValueChanged];
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 22);
        }];
    }
    return self;
}

- (void)selectTheTouchedIndex:(UISegmentedControl *)segmentControl
{
    if ([self.delegate respondsToSelector:@selector(segmentControlDidSelected:)]) {
        [self.delegate segmentControlDidSelected:segmentControl.selectedSegmentIndex];
    }
}

- (void)setupSegmentControlTitleFont:(CGFloat)font
{
    [self setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} forState:UIControlStateNormal];
}

@end
