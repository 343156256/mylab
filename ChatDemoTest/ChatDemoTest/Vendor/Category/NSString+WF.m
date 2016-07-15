//
//  NSString+NSString_WF.m
//  微信
//
//  Created by WinterChen on 15/6/17.
//  Copyright (c) 2015年 Dong.Chen. All rights reserved.
//

#import "NSString+WF.h"

@implementation NSString (WF)

- (BOOL)isTelphoneNum{
    
    NSString *telRegex = @"^1[3578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:self];
}

// 清空字符串两端的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//中文编码


@end
