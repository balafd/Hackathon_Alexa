//
//  Constants.h
//  Hackathon
//
//  Created by SHANMUGAM on 07/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface Constants : NSObject

@end
