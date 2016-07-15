//
//  TCMainServerCenter.m
//  SAX_iOS
//
//  Created by 普拉斯 on 16/3/6.
//  Copyright © 2016年 dftc. All rights reserved.
//

#import "TCMainServerCenter.h"
#import "TCAPI.h"
#import "TCSignatureGenerator.h"
#import "UIImage+Expanded.h"

NSString *const signKey = @"csO4FmBY0Hx3SKqd5uQkJn7IZTELtaRg";
NSString *TCPasswordEncryptKey = @"2DwJ5j2@";
NSString *TCNotificationTokenInvalidKey = @"TCNotificationTokenInvalidKey";
NSInteger businessType = 104;

@implementation TCMainServerCenter

+ (instancetype)manager
{
    NSURLSessionConfiguration *session = [NSURLSessionConfiguration defaultSessionConfiguration];


    TCMainServerCenter *manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:MAIN_SERVICE] sessionConfiguration:session];
//    manager.securityPolicy = [manager customSecurityPolicy]; // https 认证服务器做的配置

    
//    __weak TCMainServerCenter *weakManager = manager;
//
//   //  https 认证 双向
//    manager.securityPolicy = [manager customSecurityPolicy]; // https 认证服务器做的配置
//    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
//        
//        if ([challenge previousFailureCount] > 0) {
//            //this will cause an authentication failure
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//            TCLOG(@"Bad Username Or Password");
//            return NSURLSessionAuthChallengePerformDefaultHandling;
//        }
//        
//        //this is checking the server certificate
//        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//            
//            if ([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
//                __autoreleasing NSURLCredential *cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//                if (cre) {
//                    
//                    // FIXME:  nil ?
//                    *credential = cre;
//                    return NSURLSessionAuthChallengeUseCredential;
//                } else {
//                    return NSURLSessionAuthChallengePerformDefaultHandling;
//                }
//            } else {
//                return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//            }
//            
//        } else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
//            
//            //this handles authenticating the client certificate
//            NSData *p12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"pfx"]];
//            // your p12 password
//            CFStringRef password = CFSTR("123456");
//            const void *keys[] = { kSecImportExportPassphrase };
//            const void *values[] = { password };
//            CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
//            CFArrayRef p12Items;
//            
//            OSStatus result = SecPKCS12Import((__bridge CFDataRef)p12Data, optionsDictionary, &p12Items);
//            if(result == noErr) {
//                CFDictionaryRef identityDict = CFArrayGetValueAtIndex(p12Items, 0);
//                SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
//                
//                SecCertificateRef certRef;
//                SecIdentityCopyCertificate(identityApp, &certRef);
//                
//                SecCertificateRef certArray[1] = { certRef };
//                CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
//                CFRelease(certRef);
//                
//                __autoreleasing NSURLCredential *cre = [NSURLCredential credentialWithIdentity:identityApp certificates:(__bridge NSArray *)myCerts persistence:NSURLCredentialPersistencePermanent];
//                *credential = cre;
//                CFRelease(myCerts);
//                if (credential) {
//                    return NSURLSessionAuthChallengeUseCredential;
//                } else {
//                    return NSURLSessionAuthChallengePerformDefaultHandling;
//                }
//                
//            } else {
//                return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//            }
//            
//        } else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault || challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM) {
//            
//            // For normal authentication based on username and password. This could be NTLM or Default.
//            /*
//             DAVCredentials *cred = _parentSession.credentials;
//             NSURLCredential *credential = [NSURLCredential credentialWithUser:cred.username password:cred.password persistence:NSURLCredentialPersistenceForSession];
//             [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//             */
//            return NSURLSessionAuthChallengePerformDefaultHandling;
//        } else {
//            //If everything fails, we cancel the challenge.
//            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//        }
//        
//        return NSURLSessionAuthChallengePerformDefaultHandling;
//    }];
//
    
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
//    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET",@"HEAD",@"POST", nil];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}


- (AFSecurityPolicy *)customSecurityPolicy
{
    /**** SSL Pinning ****/
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];;
    [securityPolicy setAllowInvalidCertificates:YES];
//    securityPolicy.validatesCertificateChain = NO;
    securityPolicy.validatesDomainName = NO;
    [securityPolicy setPinnedCertificates:@[certData]];
    /**** SSL Pinning ****/
    
    return securityPolicy;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(TCResponse * responseObject))success
                      failure:(void (^)(TCResponse * responseObject, NSError *error))failure
{
    return [super GET:URLString parameters:[TCSignatureGenerator signParamsRestfulGetWithAllParams:parameters url:URLString businessType:businessType privateKey:signKey] success:^(NSURLSessionDataTask *task, id responseObject) {
        TCResponse *resp = [TCResponse requestSuccessProcessorTask:responseObject response:responseObject];
        if (resp.businessStatusCode == 0) { // 业务逻辑
            if (success) success(resp);
        } else {
            if (failure) failure(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure([TCResponse requestFailedProcessorTask:task response:error], error);
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(TCResponse *responseObject))success
                       failure:(void (^)(TCResponse * responseObject, NSError *error))failure
{
    NSDictionary *param = [TCSignatureGenerator signRestfulPOSTWithApiParams:parameters businessType:businessType privateKey:signKey];
    return [super POST:URLString parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
       
        TCResponse *resp = [TCResponse requestSuccessProcessorTask:responseObject response:responseObject];
        if (resp.businessStatusCode == 0) { // 业务逻辑
            if (success) success(resp);
        } else {
            if (failure) failure(resp, nil);
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure([TCResponse requestFailedProcessorTask:task response:error], error);
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(TCResponse * responseObject))success
                       failure:(void (^)(TCResponse * responseObject, NSError *error))failure
{
    return [super POST:URLString parameters:nil constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        TCResponse *resp = [TCResponse requestSuccessProcessorTask:responseObject response:responseObject];
        if (resp.businessStatusCode == 0) { // 业务逻辑
            if (success) success(resp);
        } else {
            if (failure) failure(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure([TCResponse requestFailedProcessorTask:task response:error], error);
    }];
}

- (NSURLSessionDataTask *)uploadImage:(UIImage *)image
                              success:(void (^)(TCResponse *responseObject))success
                              failure:(void (^)(TCResponse *responseObject, NSError *error))failure {
    image = [image compressImageToMaxFileSize:PIC_MAX_SIZE];
    return [self POST:PIC_SERVICE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
    } success:success failure:failure];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(TCResponse * responseObject))success
                      failure:(void (^)(TCResponse * responseObject, NSError *error))failure
{
    NSDictionary *param = [TCSignatureGenerator signRestfulPOSTWithApiParams:parameters businessType:businessType privateKey:signKey];
    return [super PUT:URLString parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        TCResponse *resp = [TCResponse requestSuccessProcessorTask:responseObject response:responseObject];
        if (resp.businessStatusCode == 0) { // 业务逻辑
            if (success) success(resp);
        } else {
            if (failure) failure(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure([TCResponse requestFailedProcessorTask:task response:error], error);
    }];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)( TCResponse * responseObject))success
                         failure:(void (^)(TCResponse * responseObject, NSError *error))failure
{
    NSDictionary *param = [TCSignatureGenerator signRestfulPOSTWithApiParams:parameters businessType:businessType privateKey:signKey];
    return [super DELETE:URLString parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        TCResponse *resp = [TCResponse requestSuccessProcessorTask:responseObject response:responseObject];
        if (resp.businessStatusCode == 0) { // 业务逻辑
            if (success) success(resp);
        } else {
            if (failure) failure(resp, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) failure([TCResponse requestFailedProcessorTask:task response:error], error);
    }];
}

- (void)cancelAllRequest
{
    [self.operationQueue cancelAllOperations];
}

@end
