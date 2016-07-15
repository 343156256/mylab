//
//  MyFMDBData.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/16.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "MyFMDBData.h"

#define DBO [[SqliteInterface sharedSqliteInterface] dbo]
static MyFMDBData *_instance;

@interface MyFMDBData()
@property(nonatomic,strong)FMDatabase *db;

@end

@implementation MyFMDBData
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedMyFMDBData
{
    if (_instance == nil) {
        _instance = [[MyFMDBData alloc] init];
        [_instance setupFMDB];
    }
    
    return _instance; 
}

-(void)setupFMDB{

    //1.获得数据库文件的路径

    
    NSString *fileName=[[NSBundle mainBundle] pathForResource:@"scenicspot.sqlite" ofType:nil];
    DEBUGLOG(@"数据库地址：%@",fileName);
    
     //2.获得数据库
     FMDatabase *db=[FMDatabase databaseWithPath:fileName];

    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_scenicspot (id integer PRIMARY KEY AUTOINCREMENT, productId text NOT NULL, spotName text NOT NULL, spotAliasName blob NOT NULL);"];
        if (result) {
           NSLog(@"创表成功");
        }else
        {
           NSLog(@"创表失败");
        }
     }
    self.db=db;
}
//插入数据
-(void)insert:(ScenicspotListDataInfo *)info
{
    NSString *productId = info.productId;
    NSString *spotName=info.spotName;
    NSArray *spotAliasName=info.spotAliasName;
    NSData *spotAliasNamedata = [NSKeyedArchiver archivedDataWithRootObject:spotAliasName];
     // executeUpdate : 不确定的参数用?来占位
   BOOL isOK = [self.db executeUpdate:@"INSERT INTO t_scenicspot (productId, spotName, spotAliasName) VALUES (?, ?, ?);",productId, spotName, spotAliasNamedata];
    if (!isOK) {
        DEBUGLOG(@"插入数据库失败－－%@",info.spotName);
    }
}

-(NSArray*)queryAllData{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_scenicspot"]
    ;
    FMResultSet *resultSet = [self.db executeQuery:sql];
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    while (resultSet.next){
        ScenicspotListDataInfo *spot = [[ScenicspotListDataInfo alloc]init];
        spot.productId=[resultSet stringForColumn:@"productId"];
        spot.spotName=[resultSet stringForColumn:@"spotName"];
        NSData *spotAliasNamedata=[resultSet dataForColumn:@"spotAliasName"];
        spot.spotAliasName=[NSKeyedUnarchiver unarchiveObjectWithData:spotAliasNamedata];
        [mutArray addObject:spot];
    }
    
    return mutArray;
}

 //删除数据
 -(void)deleteAllData
 {
         //    [self.db executeUpdate:@"DELETE FROM t_scenicspot;"];
         [self.db executeUpdate:@"DROP TABLE IF EXISTS t_scenicspot;"];
         [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_scenicspot (id integer PRIMARY KEY AUTOINCREMENT, productId text NOT NULL, spotName text NOT NULL, spotAliasName blob NOT NULL);"];
     }
 //模糊查询
- (NSArray *)query:(NSString *)spotName
 {
     // 1.执行查询语句
     NSString *sqlStr =[NSString stringWithFormat:@"SELECT * FROM t_scenicspot WHERE spotName like '%%%@%%'",spotName];
     FMResultSet *resultSet = [self.db executeQuery:sqlStr];

     // 2.查询结果
     NSMutableArray *mutArray = [[NSMutableArray alloc]init];
     while (resultSet.next){
         ScenicspotListDataInfo *spot = [[ScenicspotListDataInfo alloc]init];
         spot.productId=[resultSet stringForColumn:@"productId"];
         spot.spotName=[resultSet stringForColumn:@"spotName"];
         NSData *spotAliasNamedata=[resultSet dataForColumn:@"spotAliasName"];
         spot.spotAliasName=[NSKeyedUnarchiver unarchiveObjectWithData:spotAliasNamedata];
         [mutArray addObject:spot];
     }
     
     return mutArray;
}


@end
