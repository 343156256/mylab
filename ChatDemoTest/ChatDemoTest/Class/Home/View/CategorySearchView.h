//
//  CategorySearchView.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/17.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategorySearchViewDelegate <NSObject>

@optional
-(void)CategorySearchViewItemDidClick:(long)tag;

@end
@interface CategorySearchView : UIView

@property(nonatomic,weak)id<CategorySearchViewDelegate> delegate;

+(instancetype)setupCategorySearchView:(CGRect)frame;

@end
