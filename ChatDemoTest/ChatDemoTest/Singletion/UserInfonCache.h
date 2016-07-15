//
//  UserInfonCache.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/7.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfonCache : NSObject
singleton_interface(UserInfonCache)

//没用缓存
@property(nonatomic,copy)NSString *userHeadImg;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,strong)UIImage *userImage;
@property(nonatomic,copy)NSString *city;
//用了缓存
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *passWord;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *qqNum;

-(void)saveUserInfon;
-(void)readUserInfon;
-(void)clearUserInfon;

@end
