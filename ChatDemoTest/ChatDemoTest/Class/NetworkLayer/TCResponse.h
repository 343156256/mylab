//
//  TCResponse.h
//  SAX_iOS
//
//  Created by 普拉斯 on 16/4/14.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCResponse : NSObject

@property(nonatomic,strong) id businessData; // 业务逻辑data
@property(nonatomic,assign) NSInteger businessStatusCode; // 业务逻辑状态码
@property(nonatomic,strong) NSString *businessMessage; // 业务提示信息

+ (TCResponse *)requestSuccessProcessorTask:(NSURLSessionDataTask *)task response:(NSDictionary *)responseObject;
+ (TCResponse *)requestFailedProcessorTask:(NSURLSessionDataTask *)task response:(NSError *)error;

- (BOOL)isNetworkOk;

@end
