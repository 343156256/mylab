//
//  NSObject+TCHelper.h
//  TCKit
//
//  Created by ChenQi on 14-5-4.
//  Copyright (c) 2014年 Dake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TCHelper)

// file system
+ (NSString *)defaultPersistentDirectoryInDomain:(NSString *)domain;
+ (NSString *)defaultCacheDirectoryInDomain:(NSString *)domain;
+ (NSString *)defaultTmpDirectoryInDomain:(NSString *)domain;

+ (NSString *)humanDescription;
- (NSString *)humanDescription;

@end
