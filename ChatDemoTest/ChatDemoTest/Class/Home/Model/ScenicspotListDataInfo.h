//
//  ScenicspotListDataInfo.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/16.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenicspotListDataInfo : NSObject

@property(nonatomic,copy)NSString *productId;
@property(nonatomic,copy)NSString *spotName;
@property(nonatomic,strong)NSArray *spotAliasName;

+(instancetype)setupScenicspotListDataInfo:(NSDictionary *)dic;
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
