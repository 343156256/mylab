//
//  HomeTravelsCellModel.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/20.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "HomeTravelsCellModel.h"

@implementation HomeTravelsCellModel

+(instancetype)setupHomeTravelsCellModel:(NSDictionary *)dic{

    return [[self alloc]initWithDictionary:dic];
}

-(instancetype)initWithDictionary:(NSDictionary *)dic{

    self=[super init];
    if (self) {
        
        self.bookUrl=dic[@"bookUrl"];
        self.title=dic[@"title"];
        self.headImage=dic[@"headImage"];
        self.userName=dic[@"userName"];
        self.userHeadImg=dic[@"userHeadImg"];
        self.startTime=dic[@"startTime"];
        self.routeDays=dic[@"routeDays"];
        self.likeCount=[NSString stringWithFormat:@"%d",[dic[@"likeCount"] intValue]];
        self.commentCount=[NSString stringWithFormat:@"%d",[dic[@"commentCount"] intValue]];
        self.viewCount=[NSString stringWithFormat:@"%d",[dic[@"viewCount"] intValue]];
        self.text=dic[@"text"];
        
    }
    
    return self;
}
@end
