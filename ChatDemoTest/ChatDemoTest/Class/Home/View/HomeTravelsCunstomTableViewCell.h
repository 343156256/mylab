//
//  HomeTravelsCunstomTableViewCell.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/22.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTravelsCellModel.h"

@interface HomeTravelsCunstomTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UIImageView *userImage;
@property(nonatomic,strong)UIImageView *likeImage;
@property(nonatomic,strong)UILabel *userName;
@property(nonatomic,strong)UILabel *likeCount;
@property(nonatomic,strong)UIView *bgView;


-(void)setupCellData:(HomeTravelsCellModel *)model;
@end
