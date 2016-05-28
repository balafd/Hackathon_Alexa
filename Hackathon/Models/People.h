//
//  People.h
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface People : NSObject

@property ( nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *designation;
@property (readonly, nonatomic, strong) NSString *employeeID;
@property (readonly, nonatomic, strong) NSString *gplusID;
@property (readonly, nonatomic, strong) NSString *linkedin;
@property (readonly, nonatomic, strong) NSString *phone;
@property (readonly, nonatomic, strong) NSString *picURL;
@property (readonly, nonatomic, strong) NSString *twitterID;
@property (readonly, nonatomic, strong) NSString *manager;
@property (readonly, nonatomic, strong) NSString *team;
@property ( nonatomic, assign) NSInteger userID;
@property ( nonatomic, strong) NSString *emailID;
@property (nonatomic, strong) UIImage *profileImage;

@property (nonatomic) NSInteger currentStateLocationCode;
@property (nonatomic, strong) NSString *currentStatus;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end

typedef void(^PeopleListCompletionBlock)(NSArray *peoples, NSError *error);
typedef void(^PeopleDetailCompletionBlock)(People *people, NSError *error);


@interface People (API)

+ (void)fetchPeopleList:(NSInteger)page withCompletion:(PeopleListCompletionBlock)completionHandler;
+ (void)fetchPeopleDetail:(NSString *)email withCompletion:(PeopleDetailCompletionBlock)completionHandler;
+ (void)searchPeople:(NSString *)searchText withCompletion:(PeopleListCompletionBlock)completionHandler;
+ (void)getPeoplePlaceDetail:(People *)people withCompletion:(PeopleDetailCompletionBlock)completionHandler;

@end
