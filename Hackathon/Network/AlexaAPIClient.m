//
//  AlexaAPIClient.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "AlexaAPIClient.h"

static NSString * const AlexaAPIClientBaseURLString = @"https://13b8cc1d.ngrok.io";

@implementation AlexaAPIClient

+ (instancetype)sharedClient {
    static AlexaAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AlexaAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AlexaAPIClientBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
