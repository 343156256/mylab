//
//  NSDictionary+Expanded.m
//  Engineer_iOS
//
//  Created by plus on 15/10/8.
//  Copyright © 2015年 DF. All rights reserved.
//

#import "NSDictionary+Expanded.h"

@implementation NSDictionary (Expanded)

- (id)valueForKeyExceptNull:(NSString *)key
{
    id obj = [self valueForKey:key];
    return [NSNull null] == obj ? nil : obj;
}

- (NSString *)valueForKeyToStringExceptNull:(NSString *)key
{
    id obj = [self valueForKeyExceptNull:key];
    if (!obj) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}

@end
