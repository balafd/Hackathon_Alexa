//
//  Search.h
//  Hackathon
//
//  Created by SHANMUGAM on 07/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

+(NSArray *)roomsList;

+(void)getSearchResult:(NSString *)param resultBlock:(void(^)(NSDictionary *dictionary))completionBlock;

@end
