//
//  AppDelegate.h
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

