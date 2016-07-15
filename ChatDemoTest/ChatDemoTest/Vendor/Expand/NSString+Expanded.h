//
//  NSString+Expanded.h
//  Engineer_iOS
//
//  Created by plus on 15/10/8.
//  Copyright © 2015年 DF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Expanded)

- (NSString *)MD5_32;

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

+ (NSString *)dateFormat:(NSTimeInterval)date;
+ (NSString *)dateyyyyMMDDFormat:(NSTimeInterval)date;

- (BOOL)isPureNumber;
- (BOOL)isEmail;
- (BOOL)isURL;
- (BOOL)isMobile;
- (BOOL)isIdentityNumber; // 身份证
- (BOOL)isTelephone;
- (BOOL)isBlank; // 全是空白
- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)constrainedSize;
- (NSString *)encodeToPercentEscapeString;
- (NSString *)decodeFromPercentEscapeString;
- (NSString *)trimSpace;

- (BOOL)isValidPassword;
- (BOOL)isValidPrice;

@end
