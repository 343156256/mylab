//
//  TCSignatureGenerator.m
//  SAX_iOS
//
//  Created by 普拉斯 on 16/4/13.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "TCSignatureGenerator.h"
#import "NSString+Expanded.h"

@implementation TCSignatureGenerator

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams url:(NSString *)URLString businessType:(NSInteger)businessType privateKey:(NSString *)privateKey
{
    NSString *beforeSign = [TCSignatureGenerator mixParameters:allParams]; // 第一次拼接，需要sign
    NSString *resultString = [NSString stringWithFormat:@"%@%@", beforeSign, privateKey];
    if (beforeSign.length > 0) { // 如果param为空
        return [NSString stringWithFormat:@"%@?%@&business_type=%zd&sign=%@",URLString, [beforeSign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] , businessType, [resultString MD5_32]];
    } else {
        return [NSString stringWithFormat:@"%@?business_type=%zd&sign=%@",URLString, businessType,[resultString MD5_32]];
    }
}

+ (NSMutableDictionary *)signParamsRestfulGetWithAllParams:(NSDictionary *)allParams url:(NSString *)URLString businessType:(NSInteger)businessType privateKey:(NSString *)privateKey {
    NSString *beforeSign = [TCSignatureGenerator mixParameters:allParams]; // 第一次拼接，需要sign
    NSString *resultString = [NSString stringWithFormat:@"%@%@", beforeSign, privateKey];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:allParams];
    [params setObject:@(businessType) forKey:@"business_type"];
    [params setObject:[resultString MD5_32] forKey:@"sign"];
    return params;
}

+ (NSDictionary *)signRestfulPOSTWithApiParams:(NSDictionary *)allParams businessType:(NSInteger)businessType privateKey:(NSString *)privateKey
{
    NSString *resultString = [NSString stringWithFormat:@"%@%@", [TCSignatureGenerator mixParameters:allParams], privateKey];
    NSMutableDictionary *dict = [@{} mutableCopy];
    [dict setDictionary:allParams];
    
    DEBUGLOG(@"签名之前：%@ \n---------- md5:%@\n",resultString, [resultString MD5_32]);
    
    [dict setObject:[resultString MD5_32] forKey:@"sign"];
    [dict setObject:@(businessType) forKey:@"business_type"];
    
    return dict;
}

+ (NSString *)mixParameters:(NSDictionary *)param
{
    NSArray* arr = [param allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSMutableArray *array = [@[] mutableCopy];
    for (NSString *key in arr) { // 子集是一个NSDictionary或者NSArray需要jsonString一下
        id value = [param objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            // 子object jsonString
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
            if (!jsonData) {
                DEBUGLOG(@"Got an error: %@", error);
            } else {
                value = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                value = [value stringByReplacingOccurrencesOfString:@"\\" withString:@""]; // url会被自动添加转义符号/ 签名的时候不通过 需要手动去除
            }
        }
        [array addObject:[NSString stringWithFormat:@"%@=%@",key, value]];
    }
    return [array componentsJoinedByString:@"&"];
}


@end
