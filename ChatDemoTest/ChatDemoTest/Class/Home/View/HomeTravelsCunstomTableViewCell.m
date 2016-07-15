//
//  HomeTravelsCunstomTableViewCell.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/22.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "HomeTravelsCunstomTableViewCell.h"

@implementation HomeTravelsCunstomTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    
    self.backgroundColor=[UIColor whiteColor];
    
    _bgView=[[UIView alloc]init];
    _bgView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    _headImage=[[UIImageView alloc]init];
    _headImage.clipsToBounds=YES;
    _headImage.contentMode=UIViewContentModeScaleAspectFill;
    
    [_bgView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    _title=[[UILabel alloc]init];
    _title.text=@"法国帅哥";
    _title.textColor=[UIColor whiteColor];
    _title.textAlignment=NSTextAlignmentCenter;
    _title.font=[UIFont systemFontOfSize:14];
    _title.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    [_bgView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    _userImage=[[UIImageView alloc]init];
    _userImage.layer.masksToBounds=YES;
    _userImage.layer.cornerRadius=20;
    _userImage.image=PlaceholderImage;
    [_bgView addSubview:_userImage];
    [_userImage mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    _likeCount=[[UILabel alloc]init];
    _likeCount.font=[UIFont systemFontOfSize:12];
    _likeCount.text=@"666";
    [_bgView addSubview:_likeCount];
    [_likeCount mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    _likeImage=[[UIImageView alloc]init];
    _likeImage.image=[UIImage imageNamed:@"model_btn_like_red"];
    [_bgView addSubview:_likeImage];
    [_likeImage mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.bottom.mas_equalTo(-2);
        make.right.equalTo(_likeCount.mas_left).offset(-5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    _userName=[[UILabel alloc]init];
    _userName.font=[UIFont systemFontOfSize:12];
    [_bgView addSubview:_userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make, UIView *superView) {
        make.bottom.mas_equalTo(0);
        make.left.equalTo(_userImage.mas_right).offset(5);
        make.right.equalTo(_likeImage.mas_left).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    
}

-(void)setupCellData:(HomeTravelsCellModel *)model{

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:PlaceholderImage];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userHeadImg] placeholderImage:PlaceholderImage];
    self.title.text=model.title;
    self.userName.text=model.userName;
    self.likeCount.text=model.likeCount;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
