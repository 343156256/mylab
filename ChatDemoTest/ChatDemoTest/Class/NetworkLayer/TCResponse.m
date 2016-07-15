//
//  TCResponse.m
//  SAX_iOS
//
//  Created by 普拉斯 on 16/4/14.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "TCResponse.h"
#import "AFURLResponseSerialization.h"
#import "TCMainServerCenter.h"

@interface TCResponse ()

//@property(nonatomic,assign) NSInteger statusCode; // http 的statusCode
//@property(nonatomic,strong) NSString *statusMessage; // http message

@end

@implementation TCResponse

- (instancetype)init {
    if (self = [super init]) {
        self.businessStatusCode = -1;
    }
    return self;
}

+ (TCResponse *)requestSuccessProcessorTask:(NSURLSessionDataTask *)task response:(NSDictionary *)responseObject
{
    DEBUGLOG(@"response:%@",responseObject);
    TCResponse *processor = [[TCResponse alloc] init];
    if (responseObject) {
        processor.businessMessage = [responseObject valueForKeyExceptNull:@"message"];
        processor.businessStatusCode = [[responseObject valueForKeyExceptNull:@"code"] integerValue];
        processor.businessData = [responseObject valueForKeyExceptNull:@"data"];
    }
    return processor;
}

+ (TCResponse *)requestFailedProcessorTask:(NSURLSessionDataTask *)task response:(NSError *)error
{
    TCResponse *processor = [[TCResponse alloc] init];
    
    NSLog(@"%@  dommain: %@  code: %@", NSURLErrorDomain, error.domain, @(error.code));
    if (error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatus = response.statusCode;
        if (httpStatus == 401) { // sign 验证失败
            processor.businessStatusCode = 401;
            processor.businessMessage = @"签名验证失败";
            return processor;
        } else if (httpStatus == 403) { // token验证失败
            [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationTokenInvalidKey object:nil];
            return nil;
        } else if (httpStatus > 200) {
            processor.businessStatusCode = 409;
            processor.businessMessage = [NSString stringWithFormat:@"未知错误(code:%@)", @(error.code)];
            return processor;
        }
        
        NSData *data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (data) {
            // 401 sin签名错误   403 token失效
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
                processor.businessMessage = [jsonObject valueForKeyExceptNull:@"message"];
                processor.businessStatusCode = [[jsonObject valueForKeyExceptNull:@"code"] integerValue];
                processor.businessData = [jsonObject valueForKeyExceptNull:@"data"];
            }
        } else {
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                if (error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet) {
                    processor.businessStatusCode = 408;
                    processor.businessMessage = @"网络连接错误";
                } else if (error.code == NSURLErrorCannotConnectToHost) {
                    processor.businessStatusCode = 408;
                    processor.businessMessage = @"连接不上服务器";
                }
            }
        }
    } else {
        processor.businessStatusCode = 409;
        processor.businessMessage = [NSString stringWithFormat:@"未知错误(code:%@)", @(error.code)];
    }
    return processor;
}

- (BOOL)isNetworkOk
{
    if (self.businessStatusCode == 408) {
        return NO;
    }
    return YES;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"data:%@,msg:%@,code:%zd",self.businessData, self.businessMessage, self.businessStatusCode];
}

@end
