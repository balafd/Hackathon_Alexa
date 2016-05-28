//
//  FDConnectionProvider.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "FDConnectionProvider.h"
#import "AFHTTPSessionManager.h"
#import "Alexa.h"

@implementation ResponseInfo

@end

@interface FDConnectionProvider () {}

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *requestDictionary;
@property (nonatomic, strong) Alexa *alexa;
@end

@implementation FDConnectionProvider {
}

static NSString* const kAFNetworkingSerializationErrorDomain   = @"com.alamofire.error.serialization.response";

static NSInteger const kRetryCount = 2;
static NSInteger const kRetryTreshold = 1;

+ (instancetype)sharedConnectionProvider {
    static FDConnectionProvider *_sharedConnectionProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConnectionProvider = [[FDConnectionProvider alloc] init];
        _sharedConnectionProvider.requestDictionary = [NSMutableDictionary dictionary];
        _sharedConnectionProvider.alexa = [Alexa sharedManager];
    });
    
    [_sharedConnectionProvider setDefaultSerialzer];
    return _sharedConnectionProvider;
}

#pragma mark HTTP methods

- (NSURLSessionDataTask *)GETWithAuth:(NSString *)URLString
                           parameters:(id)parameters
                              success:(void (^)(ResponseInfo *responseInfo, id responseData))success
                              failure:(void (^)(ResponseInfo *responseInfo, NSError *))failure
                       withRetryCount:(NSInteger)retryCount {
    
    [self buildSessionManager];
    
    __block NSInteger count = retryCount;
    
    NSURLSessionDataTask *dataTask =   [self.sessionManager GET:URLString
                                                     parameters:parameters
                                                        success: ^(NSURLSessionDataTask *task, id responseObject) {
//                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            success(responseInfo, responseObject);
                                                        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                            
//                                                            [self removeTaskFromNetworkQueue:task];
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            
                                                            if (error.code != kCFURLErrorCancelled) {
                                                                
                                                                if (count > kRetryTreshold) {
                                                                    count --;
                                                                    [self GETWithAuth:URLString parameters:parameters success:success failure:failure withRetryCount:count];
                                                                } else {
                                                                    failure(responseInfo, [self handleError:error forTask:task]);
                                                                }
                                                            }
                                                        }];
    
    [self addTaskToNetworkQueue:dataTask];
    return dataTask;
}

- (void)GETWithAuth:(NSString *)URLString
         parameters:(id)parameters
            success:(void (^)(ResponseInfo *responseInfo, id responseData))success
            failure:(void (^)(ResponseInfo *responseInfo, NSError *))failure {
    
    [self buildSessionManager];
    
    NSURLSessionDataTask *dataTask =   [self.sessionManager GET:URLString
                                                     parameters:parameters
                                                        success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                            
//                                                            NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
//                                                            
//                                                            id responseData =   [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            success(responseInfo, responseObject);
                                                        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                            
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            if(error.code != kCFURLErrorCancelled){
                                                                [self GETWithAuth:URLString parameters:parameters success:success failure:failure withRetryCount:kRetryCount];
                                                            }
                                                        }];
    
    [self addTaskToNetworkQueue:dataTask];
}


- (NSURLSessionDataTask *)GETWithoutAuth:(NSString *)URLString
                              parameters:(id)parameters
                                 success:(void (^)(ResponseInfo *responseInfo, id responseData))success
                                 failure:(void (^)(ResponseInfo *responseInfo, NSError *))failure
                          withRetryCount:(NSInteger)retryCount {
    
    __block NSInteger count = retryCount;
    
    NSURLSessionDataTask *dataTask =   [self.sessionManager GET:URLString
                                                     parameters:parameters
                                                        success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            success(responseInfo, responseObject);
                                                        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            if (error.code != kCFURLErrorCancelled) {
                                                                
                                                                if (count > kRetryTreshold) {
                                                                    count --;
                                                                    [self GETWithAuth:URLString parameters:parameters success:success failure:failure withRetryCount:count];
                                                                } else {
                                                                    failure(responseInfo, [self handleError:error forTask:task]);
                                                                }
                                                            }
                                                        }];
    
    [self addTaskToNetworkQueue:dataTask];
    return dataTask;
}


- (void)GETWithoutAuth:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(ResponseInfo *, id))success
               failure:(void (^)(ResponseInfo *, NSError *))failure {
    
    NSURLSessionDataTask *dataTask =  [self.sessionManager GET:URLString
                                                    parameters:parameters
                                                       success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                           
                                                           ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                           [self removeTaskFromNetworkQueue:task];
                                                           
                                                           success(responseInfo, responseObject);
                                                       } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                           
                                                           ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                           [self removeTaskFromNetworkQueue:task];
                                                           
                                                           if(error.code != kCFURLErrorCancelled)
                                                               failure(responseInfo, [self handleError:error forTask:task]);
                                                       }];
    
    [self addTaskToNetworkQueue:dataTask];
}

- (void)POSTWithAuth:(NSString *)URLString
          parameters:(id)parameters
             success:(void (^)(ResponseInfo *task, id responseData))success
             failure:(void (^)(ResponseInfo *task, NSError *error))failure {
    [self buildSessionManager];
    
    NSURLSessionDataTask *dataTask =  [self.sessionManager POST:URLString
                                                     parameters:parameters
                                                        success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            success(responseInfo, responseObject);
                                                        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            if(error.code != kCFURLErrorCancelled)
                                                                failure(responseInfo, [self handleError:error forTask:task]);
                                                        }];
    
    [self addTaskToNetworkQueue:dataTask];
}

- (void)POSTWithoutAuth:(NSString *)URLString
             parameters:(id)parameters
                success:(void (^)(ResponseInfo *, id))success
                failure:(void (^)(ResponseInfo *, NSError *))failure {
//    self.sessionManager.baseURL = [NSURL URLWithString:host];
//    [self addRequestIDHeader:host];
    
    NSURLSessionDataTask *dataTask =  [self.sessionManager POST:URLString
                                                     parameters:parameters
                                                        success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            success(responseInfo, responseObject);
                                                        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                            
                                                            ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                            [self removeTaskFromNetworkQueue:task];
                                                            
                                                            NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
                                                            NSLog( @"success: %ld", (long)r.statusCode );
                                                            
                                                            if(error.code != kCFURLErrorCancelled)
                                                                failure(responseInfo, [self handleError:error forTask:task]);
                                                        }];
    
    [self addTaskToNetworkQueue:dataTask];
}

- (void)PUT:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(ResponseInfo *, id))success
    failure:(void (^)(ResponseInfo *, NSError *))failure {
    [self buildSessionManager];
    
    NSURLSessionDataTask *dataTask = [self.sessionManager PUT:URLString
                                             parameters      :parameters success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                 
                                                 ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                 [self removeTaskFromNetworkQueue:task];
                                                 
                                                 success(responseInfo, responseObject);
                                             } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                 
                                                 ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                 [self removeTaskFromNetworkQueue:task];
                                                 
                                                 if(error.code != kCFURLErrorCancelled)
                                                     failure(responseInfo, [self handleError:error forTask:task]);
                                             }];
    
    [self addTaskToNetworkQueue:dataTask];
}

- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(ResponseInfo *, id))success
       failure:(void (^)(ResponseInfo *, NSError *))failure {
    [self buildSessionManager];
    
    NSURLSessionDataTask *dataTask = [self.sessionManager DELETE:URLString
                                                   parameters   :parameters success: ^(NSURLSessionDataTask *task, id responseObject) {
                                                       
                                                       ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                       [self removeTaskFromNetworkQueue:task];
                                                       
                                                       
                                                       success(responseInfo, responseObject);
                                                   } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                                       
                                                       ResponseInfo *responseInfo = [self getResponseInfo:task];
                                                       [self removeTaskFromNetworkQueue:task];
                                                       
                                                       if(error.code != kCFURLErrorCancelled)
                                                           failure(responseInfo, [self handleError:error forTask:task]);
                                                   }];
    
    [self addTaskToNetworkQueue:dataTask];
}

#pragma mark Serializer methods
- (void)setDefaultSerialzer {
    
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.sessionManager.requestSerializer setValue:kFDAlexaMobileUserAgent forHTTPHeaderField:@"User-Agent"];
    [self.sessionManager.requestSerializer setHTTPShouldHandleCookies:NO];
    
    NSArray *serializers = @[[AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer], [AFImageResponseSerializer serializer]];
    
    self.sessionManager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:serializers];
}

#pragma mark Helper methods
- (void)buildSessionManager {
    
    if (!self.sessionManager) {

        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration: [NSURLSessionConfiguration ephemeralSessionConfiguration]];
    }
    [self setDefaultSerialzer];
//    if (_alexa.currentUser.isAuthenticated && _alexa.currentUser.authKey.length) {
    
      if (_alexa.currentUser.authKey.length) {
    
        [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", _alexa.currentUser.authKey] forHTTPHeaderField:@"Authorization"];
          
        [self.sessionManager.requestSerializer setValue:[Alexa sharedManager].currentUser.emailID forHTTPHeaderField:@"email"];
    }
}

- (NSString *)formAuthorizationData:(NSString *)key {
    NSData *plainData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:@"Basic %@", base64String];
}

- (void)addTaskToNetworkQueue:(NSURLSessionDataTask *)networkTask {
    NSString *taskIdentifier = [self networkTaskQueueKeyString:networkTask];
    
    if ([self.requestDictionary objectForKey:taskIdentifier]) {
        
        NSURLSessionDataTask *cancelTask = [self.requestDictionary objectForKey:taskIdentifier];
        
        [cancelTask cancel];
        
        [self.requestDictionary removeObjectForKey:taskIdentifier];
    }
    [self.requestDictionary setValue:networkTask forKey:taskIdentifier];
}

- (void)removeTaskFromNetworkQueue:(NSURLSessionDataTask *)networkTask {
    
    NSString *taskIdentifier = [self networkTaskQueueKeyString:networkTask];
    [self.requestDictionary removeObjectForKey:taskIdentifier];
}

- (NSString *)networkTaskQueueKeyString:(NSURLSessionDataTask *)networkTask {
    
    return [NSString stringWithFormat:@"%@?%@",networkTask.originalRequest.URL.path,networkTask.originalRequest.URL.query];
}

- (NSError *) handleError:(NSError *)error forTask:(NSURLSessionDataTask*) task {
    
    
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    
    NSInteger statusCode = response.statusCode;
    
    if([[error domain] isEqualToString:NSURLErrorDomain]){
        
//        return [FDErrorHandler mapNetworkError:error];
        
    }else if([[error domain] isEqualToString:kAFNetworkingSerializationErrorDomain]) {
        
//        return [FDErrorHandler mapNetworkSerializationError:error withCode:statusCode];
    }
    
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(@"unknown_error", nil) };
    return error;
}

- (ResponseInfo*) getResponseInfo:(NSURLSessionTask*) task {
    
    ResponseInfo *responseInfo = [[ResponseInfo alloc] init];
    responseInfo.mimeType = task.response.MIMEType;
    return responseInfo;
}

@end
