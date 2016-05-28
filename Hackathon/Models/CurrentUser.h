//
//  CurrentUser.h
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "People.h"

@interface CurrentUser : People

@property (nonatomic) BOOL isAuthenticated;
@property (nonatomic, copy) NSString *authKey;

-(void)saveCurrentUser;

-(void)loadCurrentUser;

-(void)loadFromDictionary:(NSDictionary *)dictionary;

@end
