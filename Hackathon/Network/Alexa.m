//
//  Alexa.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "Alexa.h"

@interface Alexa ()

@property (readwrite, nonatomic, strong) CurrentUser *currentUser;

@end

@implementation Alexa

+ (instancetype)sharedManager {
    static Alexa *singletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singletonInstance = [[Alexa alloc] init];
        
        singletonInstance.currentUser = [[CurrentUser alloc] init];
//        singletonInstance.currentUser.isAuthenticated = YES;
        
        [singletonInstance.currentUser loadCurrentUser];
        
    });
    return singletonInstance;
}

@end
