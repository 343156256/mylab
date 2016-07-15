//
//  ScenicspotListDataInfo.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/16.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "ScenicspotListDataInfo.h"

@implementation ScenicspotListDataInfo

+(instancetype)setupScenicspotListDataInfo:(NSDictionary *)dic{

    return [[self alloc]initWithDictionary:dic];
}
-(instancetype)initWithDictionary:(NSDictionary *)dic{

    self=[super init];
    if (self) {
        self.productId=dic[@"productId"];
        self.spotName=dic[@"spotName"];
        self.spotAliasName=dic[@"spotAliasName"];
    }
    return self;
}

@end
