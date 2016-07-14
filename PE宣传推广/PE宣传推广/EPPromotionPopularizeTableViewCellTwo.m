//
//  EPPromotionPopularizeTableViewCellTwo.m
//  PE宣传推广
//
//  Created by 陈自奎 on 16/4/13.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "EPPromotionPopularizeTableViewCellTwo.h"

@implementation EPPromotionPopularizeTableViewCellTwo

+(instancetype)setupEPPromotionPopularizeTableViewCellTwo{

    return [[[NSBundle mainBundle] loadNibNamed:@"EPPromotionPopularizeTableViewCellTwo" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
