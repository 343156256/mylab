//
//  ViewController.m
//  CoreLocationTest
//
//  Created by iecd on 15/12/17.
//  Copyright (c) 2015年 www.snake.com. All rights reserved.
//

#import "ViewController.h"
//第一步:导入框架
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
/**
 *  定位管理者
 */
@property(nonatomic,strong)CLLocationManager *mgr;

@end


@implementation ViewController
//懒加载
-(CLLocationManager *)mgr{
    if (!_mgr) {
        _mgr=[[CLLocationManager alloc]init];
    }
    return _mgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     注意: iOS7只要开始定位, 系统就会自动要求用户对你的应用程序授权. 但是从iOS8开始, 想要定位必须先"自己""主动"要求用户授权
     在iOS8中不仅仅要主动请求授权, 而且必须再info.plist文件中配置一项属性才能弹出授权窗口
     NSLocationWhenInUseDescription，允许在前台获取GPS的描述
     NSLocationAlwaysUsageDescription，允许在后台获取GPS的描述
     */
    
    // 1.创建CoreLocation管理者
    [self mgr];
    // 2.成为CoreLocation管理者的代理监听获取到的位置
    self.mgr.delegate=self;
    
    // 设置多远获取一次
//    self.mgr.distanceFilter=500;//500米获取一次
    // 设置获取位置的精确度
    /*
     kCLLocationAccuracyBestForNavigation 最佳导航
     kCLLocationAccuracyBest;  最精准
     kCLLocationAccuracyNearestTenMeters;  10米
     kCLLocationAccuracyHundredMeters;  百米
     kCLLocationAccuracyKilometer;  千米
     kCLLocationAccuracyThreeKilometers;  3千米
     */
    self.mgr.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    
    //判断ios版本
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        NSLog(@"IOS8");
        //主动要求用户对程序授权
        [self.mgr requestAlwaysAuthorization]; //请求前台和后台定位授权
//        [self.mgr requestWhenInUseAuthorization];//请求前台定位服务
        
    }else{
    
        NSLog(@"not IOS8");
        // 3.开始监听（获取位置）
        [self.mgr startUpdatingLocation];
    }
    

}
/**
 *  授权状态发生改变时调用
 *
 *  @param manager 触发事件的对象
 *  @param status  当前授权的状态
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    /*授权状态6种:
     用户从未选择过权限
     kCLAuthorizationStatusNotDetermined
     无法使用定位服务，该状态用户无法改变
     kCLAuthorizationStatusRestricted
     用户拒绝该应用使用定位服务，或是定位服务总开关处于关闭状态
     kCLAuthorizationStatusDenied
     已经授权（废弃）
     kCLAuthorizationStatusAuthorized
     用户允许该程序无论何时都可以使用地理信息
     kCLAuthorizationStatusAuthorizedAlways
     用户同意程序在可见时使用地理位置
     kCLAuthorizationStatusAuthorizedWhenInUse
     */
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {
        NSLog(@"授权成功");
        // 开始定位
        [self.mgr startUpdatingLocation];
        
    }else
    {
        NSLog(@"授权失败");
    }
}

#pragma CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    NSLog(@"%@",locations);
    // 如果只需要获取一次, 可以获取到位置之后就停止
//    [self.mgr stopUpdatingLocation];
    
    CLLocation *location=[locations lastObject];
    NSLog(@"%f--%f--speed:%f",location.coordinate.latitude,location.coordinate.longitude,location.speed);
    
}

@end
