//
//  FDConnectionProvider.h
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ResponseInfo : NSObject

@property (nonatomic, strong) NSString *mimeType;

@end

@interface FDConnectionProvider : NSObject

+ (instancetype)sharedConnectionProvider;


//HTTP Methods
- (void)GETWithAuth:(NSString *)URLString
         parameters:(id)parameters
            success:(void (^)(ResponseInfo *, id))success
            failure:(void (^)(ResponseInfo *, NSError *))failure;

- (void)GETWithoutAuth:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(ResponseInfo *, id))success
               failure:(void (^)(ResponseInfo *, NSError *))failure;


- (void)POSTWithAuth:(NSString *)URLString
          parameters:(id)parameters
             success:(void (^)(ResponseInfo *, id))success
             failure:(void (^)(ResponseInfo *, NSError *))failure;

- (void)POSTWithoutAuth:(NSString *)URLString
             parameters:(id)parameters
                success:(void (^)(ResponseInfo *, id))success
                failure:(void (^)(ResponseInfo *, NSError *))failure;


- (void)PUT:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(ResponseInfo *, id))success
    failure:(void (^)(ResponseInfo *, NSError *))failure;


- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(ResponseInfo *, id))success
       failure:(void (^)(ResponseInfo *, NSError *))failure;

@end
