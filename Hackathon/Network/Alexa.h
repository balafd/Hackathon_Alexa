//
//  Alexa.h
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentUser.h"

//static NSString * const kFDAlexaOrigin = @"http://192.168.56.182:4000";
//static NSString * const kFDAlexaOrigin = @"https://alexa.ngrok.io";
static NSString * const kFDAlexaOrigin = @"https://45867124.ngrok.io";
static NSString * const kFDAlexaMobileUserAgent = @"people_user_agent";

@interface Alexa : NSObject

@property (readonly, nonatomic, strong) CurrentUser *currentUser;

+ (instancetype)sharedManager;

@end
