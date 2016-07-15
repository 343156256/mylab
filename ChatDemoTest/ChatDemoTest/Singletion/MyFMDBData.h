//
//  MyFMDBData.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/16.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ScenicspotListDataInfo.h"

@interface MyFMDBData : NSObject


+ (instancetype)sharedMyFMDBData;

-(void)insert:(ScenicspotListDataInfo *)info;
- (NSArray *)query:(NSString *)spotName;
-(NSArray*)queryAllData;
-(void)deleteAllData;
@end
