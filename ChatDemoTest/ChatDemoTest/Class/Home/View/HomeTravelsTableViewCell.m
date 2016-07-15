//
//  HomeTravelsTableViewCell.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/17.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "HomeTravelsTableViewCell.h"
#import "HomeTravelsCellModel.h"
#import "SDImageCache.h"

@implementation HomeTravelsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[NSBundle mainBundle] loadNibNamed:@"HomeTravelsTableViewCell" owner:nil options:nil].lastObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title.backgroundColor=[UIColor lightGrayColor];
    
    self.userImg.layer.masksToBounds=YES;
    self.userImg.layer.cornerRadius=20;

}

-(void)setupCellData:(HomeTravelsCellModel *)model{

    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:PlaceholderImage];
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholderImage:PlaceholderImage];
    self.title.text=model.title;
    self.userName.text=model.userName;
    self.likeCount.text=model.likeCount;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
