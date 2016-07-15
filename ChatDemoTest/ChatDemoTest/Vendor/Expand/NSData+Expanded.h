//
//  NSData+Expanded.h
//  SAX_iOS
//
//  Created by 普拉斯 on 16/3/4.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Expanded)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
