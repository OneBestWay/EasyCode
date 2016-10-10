//
//  HTTPClient.h
//  TableViewBP
//
//  Created by GK on 2016/10/9.
//  Copyright © 2016年 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POST @"POST"
#define GET  @"GET"

@interface HTTPClient : NSObject
+ (NSURLSessionDataTask *)sendRequest:(NSString *)url
                        requestMethod:(NSString *)requestMethod
                           parameters:(NSDictionary *)parameters
                              success:(void (^) (id responseObject))success
                              failure:(void (^) (NSUInteger statusCode, NSString *error))failure;

+ (NSURLSessionUploadTask *)uploadFileTo:(NSString *)urlString
                              parameters:(id)parameters
                                fileData:(NSData *)fileData
                                    name:(NSString *)name
                                fileName:(NSString *)filename
                                mimeType:(NSString *)mimetype
                                progress:(void (^)(NSProgress * uploadProgress))progress
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSInteger statusCode,NSString *errorMSg))failure;
@end
