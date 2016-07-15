//
//  TCSignatureGenerator.h
//  SAX_iOS
//
//  Created by 普拉斯 on 16/4/13.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSignatureGenerator : NSObject

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams url:(NSString *)URLString businessType:(NSInteger)businessType privateKey:(NSString *)privateKey;
+ (NSDictionary *)signRestfulPOSTWithApiParams:(NSDictionary *)allParams businessType:(NSInteger)businessType privateKey:(NSString *)privateKey;
+ (NSMutableDictionary *)signParamsRestfulGetWithAllParams:(NSDictionary *)allParams url:(NSString *)URLString businessType:(NSInteger)businessType privateKey:(NSString *)privateKey;

@end
