//
//  NSObject+TCHelper.m
//  TCKit
//
//  Created by ChenQi on 14-5-4.
//  Copyright (c) 2014年 Dake. All rights reserved.
//

#import "NSObject+TCHelper.h"

static NSString const *kDefaultDomain = @"TCKit";

@implementation NSObject (TCHelper)

+ (NSString *)defaultPersistentDirectoryInDomain:(NSString *)domain
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:domain?:kDefaultDomain];
    //#if TARGET_IPHONE_SIMULATOR
    //    path = [path stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    //#endif
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dir
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:NULL]) {
        NSAssert(false, @"create directory failed.");
        dir = nil;
    }
    
    return dir;
}

+ (NSString *)defaultCacheDirectoryInDomain:(NSString *)domain
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:domain?:kDefaultDomain];
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dir
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:NULL]) {
        NSAssert(false, @"create directory failed.");
        dir = nil;
    }
    return dir;
}

+ (NSString *)defaultTmpDirectoryInDomain:(NSString *)domain
{
    NSString *dir = [NSTemporaryDirectory() stringByAppendingPathComponent:domain?:kDefaultDomain];
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dir
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:NULL]) {
        NSAssert(false, @"create directory failed.");
        dir = nil;
    }
    
    return dir;
}

+ (NSString *)humanDescription
{
    return nil;
}

- (NSString *)humanDescription
{
    return [self.class humanDescription];
}


@end
