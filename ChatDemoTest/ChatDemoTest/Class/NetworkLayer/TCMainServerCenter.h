//
//  TCMainServerCenter.h
//  SAX_iOS
//
//  Created by 普拉斯 on 16/3/6.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "TCResponse.h"

extern NSString *TCNotificationTokenInvalidKey;
extern NSString *TCPasswordEncryptKey;


@interface TCMainServerCenter : AFHTTPSessionManager

+ (instancetype)manager;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(TCResponse *responseObject))success
                      failure:(void (^)(TCResponse *responseObject, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(TCResponse *responseObject))success
                       failure:(void (^)(TCResponse * responseObject, NSError *error))failure;

// 上传表单，主要是图片post上传
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(TCResponse *responseObject))success
                       failure:(void (^)(TCResponse *responseObject, NSError *error))failure;

// 上传图片
- (NSURLSessionDataTask *)uploadImage:(UIImage *)image
                              success:(void (^)(TCResponse *responseObject))success
                              failure:(void (^)(TCResponse *responseObject, NSError *error))failure;


- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(TCResponse *responseObject))success
                      failure:(void (^)(TCResponse *responseObject, NSError *error))failure;

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(TCResponse *responseObject))success
                         failure:(void (^)(TCResponse *responseObject, NSError *error))failure;

-(void)cancelAllRequest;

@end
