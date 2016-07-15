//
//  HomeTravelsCellModel.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/20.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTravelsCellModel : NSObject

@property(nonatomic,copy)NSString *bookUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *headImage;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userHeadImg;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *routeDays;
@property(nonatomic,copy)NSString *likeCount;
@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,copy)NSString *viewCount;
@property(nonatomic,copy)NSString *text;

+(instancetype)setupHomeTravelsCellModel:(NSDictionary *)dic;
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
