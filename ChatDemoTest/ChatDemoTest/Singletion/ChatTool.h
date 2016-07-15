//
//  ChatTool.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/6.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ChatTool : NSObject
singleton_interface(ChatTool)

typedef void (^ChatLoginSucc)(BOOL isScuss);

-(void)setupChatStream:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
-(void)loginWithUserName:(NSString *)userName withPWD:(NSString *)password scuss:(void(^)())scuss fail:(void(^)(EMError *err))fail;
-(void)registWithUserName:(NSString *)userName withPWD:(NSString *)password scuss:(void(^)())scuss fail:(void(^)(EMError *err))fail;
-(void)loginOut;

@end
