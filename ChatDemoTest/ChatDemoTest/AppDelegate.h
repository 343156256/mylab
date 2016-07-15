//
//  AppDelegate.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/2.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDKFull.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@end

