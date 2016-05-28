//
//  People.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "People.h"
#import "FDConnectionProvider.h"

@interface People ()
//@property (readwrite, nonatomic, strong) NSString *name;
//@property (readwrite, nonatomic, strong) NSString *designation;
//@property (readwrite, nonatomic, strong) NSString *employeeID;
//@property (readwrite, nonatomic, strong) NSString *gplusID;
//@property (readwrite, nonatomic, strong) NSString *linkedin;
//@property (readwrite, nonatomic, strong) NSString *phone;
//@property (readwrite, nonatomic, strong) NSString *picURL;
//@property (readwrite, nonatomic, strong) NSString *twitterID;
//@property (readwrite, nonatomic, strong) NSString *manager;
//@property (readwrite, nonatomic, strong) NSString *team;
//@property (nonatomic, assign) NSInteger userID;
//@property (nonatomic, strong) NSString *emailID;

@end

@implementation People

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _userID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    _name = [attributes valueForKeyPath:@"name"];
    _designation = attributes[@"designation"];
    _emailID = attributes[@"email"];
    _employeeID = attributes[@"employee_id"];
    _name = attributes[@"name"];
    _phone = attributes[@"phone"];
    _picURL = attributes[@"pic_url"];
    _linkedin = attributes[@"linkedin"];
    _gplusID = attributes[@"gplus_id"];
    return self;
}

@end

@implementation People (API)

+ (void)fetchPeopleList:(NSInteger)page withCompletion:(PeopleListCompletionBlock)completionBlock {
    
    NSString *requestPath = [NSString stringWithFormat:@"https://656d4cbe.ngrok.io/users?page=%ld&format=json", (long)page];
    
    [[FDConnectionProvider sharedConnectionProvider] GETWithAuth:requestPath parameters:nil success:^(ResponseInfo *responseInfo, id responseData) {

        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *peoplesFromResponse = [responseData valueForKey:@"users"];
            NSMutableArray *peoples = [NSMutableArray arrayWithCapacity:peoplesFromResponse.count];
            for (NSDictionary *peopleAttributes in peoplesFromResponse) {
                People *people = [[People alloc] initWithAttributes:peopleAttributes ];
                [peoples addObject:people];
            }
            if (completionBlock) {
                completionBlock(peoples, nil);
            }
        } else {
            NSLog(@"people %@", responseData);
            if (completionBlock) {
                completionBlock([NSArray array], [NSError errorWithDomain:@"bad_Response" code:1 userInfo:nil]);
            }
        }
        
    } failure:^(ResponseInfo *responseInfo, NSError *error) {
        completionBlock(nil, error);
    }];
}

+ (void)fetchPeopleDetail:(NSString *)email withCompletion:(PeopleDetailCompletionBlock)completionHandler {
    
    NSArray *userNames = [email componentsSeparatedByString:@"@"];
    if (userNames.count) {

        NSString *userName = userNames.firstObject;
        NSString *requestPath = [NSString stringWithFormat:@"https://656d4cbe.ngrok.io/%@?format=json", userName];
        [[FDConnectionProvider sharedConnectionProvider] GETWithAuth:requestPath parameters:nil success:^(ResponseInfo *responseInfo, id responseData) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *peopleDict = [responseData valueForKey:@"user"];
                
                People *people = [[People alloc] initWithAttributes:peopleDict];
                
                completionHandler(people, nil);
            } else {
                NSLog(@"people %@", responseData);
                completionHandler(nil, [NSError errorWithDomain:@"bad_Response" code:1 userInfo:nil]);
            }
        } failure:^(ResponseInfo *responseInfo, NSError *error) {
            completionHandler(nil, error);
        }];
    }
}

+ (void)searchPeople:(NSString *)searchText withCompletion:(PeopleListCompletionBlock)completionHandler {
    
    NSString *requestPath = [NSString stringWithFormat:@"https://656d4cbe.ngrok.io/users?format=json&q[search_str]=%@", searchText];
    [[FDConnectionProvider sharedConnectionProvider] GETWithAuth:requestPath parameters:nil success:^(ResponseInfo *responseInfo, id responseData) {
        
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *peoples = [NSMutableArray new];
            NSArray *peoplesList = [responseData valueForKey:@"users"];
            
            for (NSDictionary *peopleDict in peoplesList) {
                People *people = [[People alloc] initWithAttributes:peopleDict];
                
                [peoples addObject:people];
            }
            completionHandler(peoples, nil);
        } else {
            NSLog(@"people %@", responseData);
            completionHandler(nil, [NSError errorWithDomain:@"bad_Response" code:1 userInfo:nil]);
        }
    } failure:^(ResponseInfo *responseInfo, NSError *error) {
        completionHandler(nil, error);
    }];
}


//http://192.168.57.95:3000/alexa/api/


+ (void)getPeoplePlaceDetail:(People *)people withCompletion:(PeopleDetailCompletionBlock)completionHandler {
    
    NSString *requestPath = [NSString stringWithFormat:@"http://192.168.57.95:3000/alexa/api/current_info"];
    NSDictionary *param = @{@"user_email":people.emailID};
    [[FDConnectionProvider sharedConnectionProvider] POSTWithoutAuth:requestPath parameters:param success:^(ResponseInfo *responseInfo, id responseData) {
        
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            people.currentStateLocationCode = [responseData[@"current_state_of_location"] integerValue];
            
            switch (people.currentStateLocationCode) {
                case 0:
                    people.currentStatus = @" ";
                    break;
                case 1:
                    people.currentStatus = [NSString stringWithFormat:@"is currently in office, near %@", responseData[@"office_location"]];
                    break;
                case 2:
                    people.currentStatus = @" is offline!";
                    break;
                case 3:
                    people.currentStatus = @"Doesn't wish to show his status";
                    break;
                case 4:
                    people.currentStatus = @"Hasn't started using A.L.E.X.A";
                    break;
                default:
                    break;
            }
            completionHandler(people, nil);
        } else {
            NSLog(@"people %@", responseData);
            completionHandler(people, nil);
        }
    } failure:^(ResponseInfo *responseInfo, NSError *error) {
        completionHandler(nil, error);
    }];
}

@end

