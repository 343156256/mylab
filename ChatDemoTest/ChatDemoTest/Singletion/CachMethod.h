//
//  CachMethod.h
//  
//
//  Created by iecd on 15/8/24.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CachMethod : NSObject

/**
 *  新的数据缓存方法，基于FMDB，param用于拼数据对应的key
 */
+ (void)saveData:(id)obj at:(NSDictionary *)param with:(NSString *)key;
+ (id)dataWithParams:(NSDictionary *)param with:(NSString *)key;
+ (BOOL)clearCache;

/**
 *  将数据存到沙盒
 *
 *  @param data     NSData数据
 *  @param fileName 存储的文件识别，取数据时对应此文件名取
 */
+ (void)CachWithData:(NSData *)data fileName:(NSString *)fileName;

/**
 *  根据文件名从沙盒取出数据
 *
 *  @param fileName 文件名
 *
 *  @return 返回值为NSData类型，需要解析
 */
+ (NSData *)getDataWithFileName:(NSString *)fileName;

@end
