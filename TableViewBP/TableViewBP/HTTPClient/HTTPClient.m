//
//  HTTPClient.m
//  TableViewBP
//
//  Created by GK on 2016/10/9.
//  Copyright © 2016年 GK. All rights reserved.
//

#import "HTTPClient.h"
#import "NSArray+Additions.h"
#import "NSDictionary+Additions.h"

#define kErrorClientCannotDecodeContentData 601  //解析错误
#define kErrorUserAuthenticationRequired    @"5015"  //需要用户登录授权
#define kPayPassportForHttps                    @"https://prepaypassport.cnsuning.com/ids"  //用户登录的Url

// session超时
#define  kLoginSessionTimeoutNotification           @"LoginSessionTimeoutNotification"

static inline NSString * HTTPUserAgent() {
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iPhone iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent)
    {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false))
            {
                userAgent = mutableUserAgent;
            }
        }
    }
    
    return userAgent;
}

@interface HTTPManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation HTTPManager

+ (HTTPManager *)sharedHHTPManager
{
    static HTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        manager = [[HTTPManager alloc] init];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //这里可以注册NSURLProtocol的子类，来对URL的加载行为进行全方位的控制，比如说拦截图片请求该从本地加载
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        sessionManager.securityPolicy.allowInvalidCertificates = YES; //only for test environment
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        requestSerializer.timeoutInterval = 28;
        NSString *userAgent = HTTPUserAgent();
        [requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [requestSerializer setValue:appVersion forHTTPHeaderField:@"appVersion"];
        
        [requestSerializer setValue:@"12" forHTTPHeaderField:@"terminal"];
        [requestSerializer setValue:@"terminal_type" forHTTPHeaderField:@"terminal_type"];
        [requestSerializer setValue:[[NSString generateGuid] MD5EncodedString]   forHTTPHeaderField:@"uniqueFlag"];
        
        sessionManager.requestSerializer = requestSerializer;
        
        //设置响应
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
        [acceptContentTypes addObject:@"text/plain"];
        [acceptContentTypes addObject:@"text/html"];
        responseSerializer.acceptableContentTypes = acceptContentTypes;
        
        sessionManager.responseSerializer = responseSerializer;
        
        manager.sessionManager = sessionManager;
    });
    return manager;
}

@end

@implementation AFHTTPSessionManager (requestMethod)

- (NSURLSessionDataTask *)sendRequest:(NSString *)urlString
                        requestMethod:(NSString *)requestMethod
                           parameters:(id)parameters
                              success:(void (^) (NSURLSessionDataTask *task,id responseObject))success
                              failure:(void (^) (NSURLSessionDataTask *task,NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer  requestWithMethod:requestMethod URLString:[[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil,serializationError);
            });
        }
        return nil;
    }
    
    __block __weak NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error && !responseObject) {
        //if (error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(nil,error);
                });
            }
        }else {
            if (success) {
                success(task,responseObject);
            }
        }
    }];
    return task;
}

@end

@implementation HTTPClient
//支持get和post
+ (NSURLSessionDataTask *)sendRequest:(NSString *)url
                        requestMethod:(NSString *)requestMethod
                           parameters:(NSDictionary *)parameters
                              success:(void (^) (id responseObject))success
                              failure:(void (^) (NSUInteger statusCode, NSString *error))failure
{
    //如果有本地自写的缓存，在这里读取，但除非必要建议用NSURLCache
    AFHTTPSessionManager *sessionManager = [HTTPManager sharedHHTPManager].sessionManager;
    //可以针对某个特定的URL来修改requestSerializer和responseSerializer
    
    __block __weak NSURLSessionDataTask *task = [sessionManager sendRequest:url requestMethod:requestMethod parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)[task response];
        NSDictionary *responseHeaders = nil;
        if (response) {
            responseHeaders = [response allHeaderFields];
        }
        if (!responseObject) {
            NSInteger errorCode = kErrorClientCannotDecodeContentData;
            NSString *errorMsg = @"The response data cnanot be decoded";
            NSLog(@"\n%@ FAILED: \n%@\nERROR_CODE:\%ld\nERROR: %@",requestMethod,[url urlByAppendingDictNoEncode:parameters],(long)errorCode,errorMsg);
            NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试（%ld）",(long)errorCode];
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(errorCode,tError);
                });
            }
        }else if ([responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"responseObject is an aray object");
            NSLog(@"\n%@ SUCCESS: \n%@\nRESPONSE: \n%@",requestMethod,[url urlByAppendingDictNoEncode:parameters],[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil] encoding:NSUTF8StringEncoding]);
            
            NSArray *responseObjectArray = (NSArray *)responseObject;
            NSArray *responseObjectResult = [responseObjectArray arrayByRemovingNullRecursively:YES];
            
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(responseObjectResult);
                });
            }
        }else { //NSDictionary
            NSLog(@"responseObject is an aray object");
            NSLog(@"\n%@ SUCCESS: \n%@\nRESPONSE: \n%@",requestMethod,[url urlByAppendingDictNoEncode:parameters],[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil] encoding:NSUTF8StringEncoding]);
            
            NSDictionary *responseObjectDic = (NSDictionary *)responseObject;
            NSDictionary *responseObjectResult = [responseObjectDic dictionaryByRemovingNullRecursively:YES];
            
            NSString *errorCode = [responseObjectResult objectForKey:@"errorCode"];
            
            if ([errorCode isEqualToString:kErrorUserAuthenticationRequired]) {
                NSString *loginUrl = [NSString stringWithFormat:@"%@/login",kPayPassportForHttps];
                
                if (![url hasPrefix:loginUrl]) {
                    
                    //用户未登录或会话实效 5015
                    NSMutableDictionary *requestMDic = [[NSMutableDictionary alloc] init];
                    [requestMDic setObject:IsStrEmpty(url)?@"":url forKey:@"url"];
                    [requestMDic setObject:IsStrEmpty(requestMethod)?@"":requestMethod forKey:@"requestMethod"];
                    if (parameters != nil) {
                        [requestMDic setObject:parameters forKey:@"parameters"];
                    }
                    if (success != nil) {
                        [requestMDic setObject:success forKey:@"success"];
                    }
                    if (failure != nil) {
                        [requestMDic setObject:failure forKey:@"failure"];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSessionTimeoutNotification object:requestMDic];
                }
            }else {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success (responseObjectResult);
                    });
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:{
                tError = [NSString stringWithFormat:@"连接服务器超时（%ld）,请检查你的网络或稍后再试",(long)[error code]];
                break;
                break;
            }
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired: {
                tError = [NSString stringWithFormat:@"无法连接到服务器（%ld）,请检查你的网络或稍后重试",(long)[error code]];
                break;
            }
            case NSURLErrorHTTPTooManyRedirects: {
                tError = [NSString stringWithFormat:@"太多http重定向（%ld）,请检查你的网络连接稍后再试",(long)[error code]];
                break;
            }
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙, 请稍后再试(%ld)",(long)[error code]];
                break;
        }
        
        NSLog(@"\n%@ FAILED: \n%@\nERROR_CODE: %ld\nERROR: %@", requestMethod, [url urlByAppendingDictNoEncode:parameters], (long)[error code], tError);
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(labs([error code]),tError);
            });
        }

    }];
    [task resume];
    return task;
}

+ (NSURLSessionUploadTask *)uploadFileTo:(NSString *)urlString
                              parameters:(id)parameters
                                fileData:(NSData *)fileData
                                    name:(NSString *)name
                                fileName:(NSString *)filename
                                mimeType:(NSString *)mimetype
                                progress:(void (^)(NSProgress * uploadProgress))progress
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSInteger statusCode,NSString *errorMSg))failure
{
    //对url进行字符串编码，但对？&等无效
    NSString *urltemp = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:filename mimeType:mimetype];
        
    } error:nil];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [request setValue:appVersion forHTTPHeaderField:@"appVersion"];
    [request setValue:[[NSString generateGuid] MD5EncodedString] forHTTPHeaderField:@"uniqueFlag"];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain",@"application/json", nil];//设置可接受的类型
    manager.responseSerializer = responseSerializer;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSString *tError = nil;
            switch ([error code]) {
                    
                case NSURLErrorTimedOut:
                {
                    tError = [NSString stringWithFormat:@"连接服务器超时(%ld), 请检查你的网络或稍后重试", (long)[error code]];
                    break;
                }
                    
                case NSURLErrorBadURL:
                case NSURLErrorUnsupportedURL:
                case NSURLErrorCannotFindHost:
                case NSURLErrorDNSLookupFailed:
                case NSURLErrorCannotConnectToHost:
                case NSURLErrorNetworkConnectionLost:
                case NSURLErrorNotConnectedToInternet:
                case NSURLErrorUserCancelledAuthentication:
                case NSURLErrorUserAuthenticationRequired:
                case NSURLErrorSecureConnectionFailed:
                case NSURLErrorServerCertificateHasBadDate:
                case NSURLErrorServerCertificateUntrusted:
                case NSURLErrorServerCertificateHasUnknownRoot:
                case NSURLErrorServerCertificateNotYetValid:
                case NSURLErrorClientCertificateRejected:
                case NSURLErrorClientCertificateRequired:
                    tError = [NSString stringWithFormat:@"无法连接到服务器(%ld), 请检查你的网络或稍后重试",(long)[error code]];
                    break;
                    
                case NSURLErrorHTTPTooManyRedirects:
                    tError = [NSString stringWithFormat:@"太多HTTP重定向(%ld), 请检查你的网络或稍后重试",(long)[error code]];
                    break;
                    
                default:
                {
                    tError = [NSString stringWithFormat:@"系统繁忙, 请稍后再试(%ld)",(long)[error code]];
                    break;
                }
                    
            }
            
            NSLog(@"UPLOAD FILE FAILED: \n%@\nERROR_CODE: %ld\nERROR: %@", [urltemp urlByAppendingDictNoEncode:parameters], (long)[error code], tError);
            
            if (failure)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([error code], tError);
                });
            }
        }else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(responseObject);
                });
            }
        }
    }];
    return uploadTask;
}
@end
