//
//  UserInfonCache.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/7.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "UserInfonCache.h"

@implementation UserInfonCache
singleton_implementation(UserInfonCache)


-(void)saveUserInfon{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName forKey:@"userName"];
    [defaults setObject:self.passWord forKey:@"passWord"];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.qqNum forKey:@"qqNum"];
    [defaults synchronize];
}

-(void)readUserInfon{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userName=[defaults objectForKey:@"userName"];
    self.passWord=[defaults objectForKey:@"passWord"];
    self.email=[defaults objectForKey:@"email"];
    self.qqNum=[defaults objectForKey:@"qqNum"];
    
}
-(void)clearUserInfon{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.userName=nil;
    self.passWord=nil;
    self.email=nil;
    self.qqNum=nil;
    [defaults setObject:self.userName forKey:@"userName"];
    [defaults setObject:self.passWord forKey:@"passWord"];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.qqNum forKey:@"qqNum"];
    [defaults synchronize];
}

@end
