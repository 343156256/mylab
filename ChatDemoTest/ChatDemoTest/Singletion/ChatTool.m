//
//  ChatTool.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/6.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "ChatTool.h"



#define EaseMobAppKey @"343156256#mypodstest"
#define APNSCentName_develop @"development_push"
#define APNSCentName_produce @"production_push"

@interface ChatTool()<EMClientDelegate,EMChatManagerDelegate>

@end

@implementation ChatTool
singleton_implementation(ChatTool)


-(void)setupChatStream:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀）。
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobAppKey];
    options.apnsCertName = APNSCentName_develop;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //回调代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:EaseMobAppKey
                                       apnsCertName:APNSCentName_develop
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

}

//登录方法
-(void)loginWithUserName:(NSString *)userName withPWD:(NSString *)password scuss:(void (^)())scuss fail:(void (^)(EMError *err))fail{

    EMError *error = [[EMClient sharedClient] loginWithUsername:userName password:password];
    
    if (!error)
    {
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        if (scuss) {
            scuss();
        }
    }else{
        if (fail) {
            fail(error);
        }
    }
}

//注册方法
-(void)registWithUserName:(NSString *)userName withPWD:(NSString *)password scuss:(void (^)())scuss fail:(void (^)(EMError *err))fail{

    EMError *error = [[EMClient sharedClient] registerWithUsername:userName password:password];
    if (error==nil) {
       
        if (scuss) {
            scuss();
        }
    }else{
        if (fail) {
            fail(error);
        }
    }
}

-(void)loginOut{

    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
}


/*!
 *  自动登录返回结果
 *
 *  @param aError 错误信息
 */
- (void)didAutoLoginWithError:(EMError *)aError{
    
    //自动登录返回结果
    
    
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice{
    
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer{
    
}


@end
