//
//  HomeTravelsTableViewCell.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/17.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTravelsCellModel;

@interface HomeTravelsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;

-(void)setupCellData:(HomeTravelsCellModel *)model;

@end
