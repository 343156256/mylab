//
//  CachMethod.m
//  
//
//  Created by iecd on 15/8/24.
//
//

#import "CachMethod.h"

@implementation CachMethod

static FMDatabase *_db;
+(void)initialize
{
    //1打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CacheData.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_CacheData (id integer PRIMARY KEY, datas blob NOT NULL,keystr text NOT NULL,time text NOT NULL);"];
}

+ (id)dataWithParams:(NSDictionary *)param with:(NSString *)key
{
    NSString *keyStr = [self parseParams:param];
    keyStr = [NSString stringWithFormat:@"%@//%@",key,keyStr];
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_CacheData WHERE keystr=?;",keyStr];
    if (set.next) {
        //取数据后更新时间,以用户阅览该页数据的时间为最后时间
        NSDate *time = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [formatter stringFromDate:time];
        [_db executeUpdate:@"UPDATE t_CacheData SET time=? WHERE keystr=?;",timeStr,keyStr];
        
        NSData *data=[set objectForColumnName:@"datas"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id obj = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return obj;
    }else
        return nil;
}

+ (void)saveData:(id)obj at:(NSDictionary *)param with:(NSString *)key
{
    
    NSMutableData *data=[NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:obj forKey:key];
    [archiver finishEncoding];
    
    NSString *keyStr = [self parseParams:param];
    keyStr = [NSString stringWithFormat:@"%@//%@",key,keyStr];
    //获取当前时间，缓存进去，方便以后根据时间清除缓存
    NSDate *time = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:time];
    
    if ([self dataWithParams:param with:key]) {
        [_db executeUpdate:@"UPDATE t_CacheData SET datas=?,time=? WHERE keystr=?;",data,timeStr,keyStr];
    }else
    {
        [_db executeUpdate:@"INSERT INTO t_CacheData(datas,time,keystr) VALUES (?,?,?);",data,timeStr,keyStr];
    }
}

/**按最后查看的时间超过一个月来删除数据 */
+ (BOOL)clearCache
{
    //获取当前时间
    NSDate *time = [NSDate date];
    //往前调一个月
   time = [time dateByAddingTimeInterval:-30*3600*24];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:time];
    return [_db executeUpdate:@"DELETE FROM t_CacheData WHERE (time<?)",timeStr];
}

//帮助方法 字典转str
+(NSString*)parseParams:(NSDictionary*)parsms{
    //将字典拼接成字符串
    NSString *keyValueFormate;
    NSMutableString *result = [NSMutableString string];
    NSEnumerator *keyEnum =[parsms keyEnumerator];
    id key;
    while (key=[keyEnum nextObject]) {
        keyValueFormate =[NSString stringWithFormat:@"%@=%@&",key,[parsms valueForKey:key]];
        [result appendString:keyValueFormate];
    }
    return result;
}

/**
 *  老方法，每个数据存一个文件，舍弃使用
 */
+ (void)CachWithData:(NSData *)data fileName:(NSString *)fileName
{
    [data writeToFile:[self filePath:fileName] atomically:YES];
}

+ (NSData *)getDataWithFileName:(NSString *)fileName
{
    NSData *data = [NSData dataWithContentsOfFile:[self filePath:fileName]];
    return data;
}

+ (NSString *)filePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachPath = [paths firstObject];
    return [cachPath stringByAppendingPathComponent:fileName];
}


@end
