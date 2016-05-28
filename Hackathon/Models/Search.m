//
//  Search.m
//  Hackathon
//
//  Created by SHANMUGAM on 07/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "Search.h"
#import "FDConnectionProvider.h"

@implementation Search

+(NSArray *)roomsList
{
    return @[@"King's Landing",@"Red October",@"Leaky Cauldron",@"Limbo",@"Pandora",@"Hogwarts",@"Atlantis",@"Bedrock",@"Gotham City",@"El Dorado",@"Malgudi",@"Stark Tower",@"Metropolis",@"Springfield",@"War Room",@"Winterfell",@"Hardhome",
             @"Naboo",
             @"Follywood",
             @"Mushroom Kingdom",
             @"Sesame Street",
             @"Dexter’s Lab",
             @"Calvinball",
             @"Narnia",
             @"Pong",
             @"Central Perk",
             @"Neverland",
             @"Paradise Falls",
             @"Megakat City",
             @"Vulcan",
             @"Shangri-La",
             @"Baker Street",
             @"Hotel California",
             @"1984"
             ];
}

+(void)getSearchResult:(NSString *)param resultBlock:(void(^)(NSDictionary *dictionary))completionBlock
{
    NSMutableString *string =   [NSMutableString stringWithString:param];
    
    [[self roomsList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if([string containsString:obj])
        {            
            [string replaceOccurrencesOfString:obj withString:[NSString stringWithFormat:@"<%@>",obj] options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
            
        }
        
    }];
    
    [[FDConnectionProvider sharedConnectionProvider] GETWithAuth:@"http://192.168.56.182:4000/home/question" parameters:@{@"Query":string} success:^(ResponseInfo *responseInfo, id data) {
            
            data    =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        completionBlock(data);
        
        } failure:^(ResponseInfo *responseInfo, NSError *error) {
            
        }];
}

@end
