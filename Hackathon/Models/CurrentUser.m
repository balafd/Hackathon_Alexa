//
//  CurrentUser.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

-(void)loadFromDictionary:(NSDictionary *)dictionary
{
    NSArray *array  =   dictionary[@"Outcome"];
    
    self.authKey    =   array.firstObject;
    
    self.name       =   array[2];
    
    self.emailID    =   array[3];
}

-(void)loadCurrentUser
{
    self.authKey    =   [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] ?: @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2VtYWlsIjoiZ29rdWxAZnJlc2hkZXNrLmNvbSIsImV4cCI6MTQ2MjcxNzAwMn0.xPtB8eI3Fy0MNNh55oXNDqiL4Z4aiF4I2IPS-ka83kQ";
    
    self.emailID    =   [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

-(void)saveCurrentUser
{
    [[NSUserDefaults standardUserDefaults] setObject:self.authKey forKey:@"auth_token"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.emailID forKey:@"email"];
}

@end
