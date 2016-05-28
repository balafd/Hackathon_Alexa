//
//  AppDelegate.m
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ContainerViewController.h"
#import "SVProgressHUD.h"
#import "Alexa.h"
#import "AFNetworking/AFNetworking/AFNetworkReachabilityManager.h"
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

typedef NS_ENUM(NSInteger, PRESENCE_STATE) {
    InFreshdesk = 1,
    NotInFreshdesk,
    ChoseNottoPublishtoAlexa,
    NotStartedToUseAlexa
};

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer *presenceTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [application setMinimumBackgroundFetchInterval:1.0];
    
    [GIDSignIn sharedInstance].clientID = @"1074494656695-vlqlvn8i83l1qt0dnlfdd4gjie1njnvn.apps.googleusercontent.com";

    [self setHomeViewController];

    /*
    if ([[GIDSignIn sharedInstance] hasAuthInKeychain]) {
        
        [self setHomeViewController];
    } else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [_window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
    }
     */
    return YES;
}

- (void)setHomeViewController {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [_window setRootViewController:(UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"]];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
 
    [self trackPresence:[self getPresenceState] completionHandler:^(UIBackgroundFetchResult result) {
       
        completionHandler(result);
    }];
}

- (void)trackPresence:(PRESENCE_STATE)presence completionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"Wifi mac id : %@", [self getWifiBSSID]);
    
    if ([[GIDSignIn sharedInstance] hasAuthInKeychain]) {
        
        NSURL   *url    =   [NSURL URLWithString:@"http://192.168.57.95:3000/alexa/api/update_user_info"];
        NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:[Alexa sharedManager].currentUser.emailID, @"user_email", [self getWifiBSSID], @"wifi_mac_id", [NSNumber numberWithInteger:presence], @"current_state", @"ios", @"platform", nil];
        NSError *error;
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:params
                                                           options:0
                                                             error:&error];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsondata];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if ([data bytes]) {
                completionHandler(UIBackgroundFetchResultNewData);
            } else {
                completionHandler(UIBackgroundFetchResultNoData);
            }
            NSLog(@"Result");
        }];
        [task resume];
    }
}

- (PRESENCE_STATE)getPresenceState {
    if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        
        NSString *wifiSSID = [self getWifiSSID];
        NSArray *ssidArray  = @[@"Freshdesk-WiFi", @"Freshdesk-Handhelds", @"Freshdesk-Guest"];
        __block BOOL status =   NO;
        [ssidArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ssid = obj;
            if ([ssid isEqualToString:wifiSSID] == NSOrderedSame) {
                status  =   YES;
            }
        }];
        if (status) {
            return InFreshdesk;
        }
    }
    return NotInFreshdesk;
}

- (NSString *)getWifiBSSID {
    if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        NSString *wifiName = nil;
        NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
        for (NSString *name in interFaceNames) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        
            if (info[@"BSSID"]) {
                wifiName = info[@"BSSID"];
            }
        }
        
        return wifiName;
    }
    return nil;
}

- (NSString *)getWifiSSID {
    
//    if([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi])
    {
        NSString *wifiName = nil;
        NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
        
        for (NSString *name in interFaceNames) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
            
            if (info[@"SSID"]) {
                wifiName = info[@"SSID"];
            }
        }
        return wifiName;
    }
    
    return nil;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    _presenceTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(BackgroundRun) userInfo:nil repeats:YES];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of appliationWillTerminate: when the user quits.
}

- (void)BackgroundRun {
    NSLog(@"Hackathon Background Mode");
    
    [self trackPresence:[self getPresenceState] completionHandler:^(UIBackgroundFetchResult result) {
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self trackPresence:[self getPresenceState] completionHandler:^(UIBackgroundFetchResult result) {
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"signIn %i",[[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation]);
    
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if (!error) {
        [self authenticateSignedInUser:user.profile.email temp:user.authentication.idToken];
    }
}

- (void)authenticateSignedInUser:(NSString *)token temp:(NSString *)code{

    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://d9f62d27.ngrok.io/auth/mobile?email=%@&code=%@",token,code]];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:token, @"email", @"gplus", @"provider", nil];
    NSError *error;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:params
                                                       options:0
                                                         error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsondata];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __weak AppDelegate *appDelegate = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                 [SVProgressHUD dismiss];
                               });
                               if (!error) {
                                   __strong    AppDelegate *strongDelegate =   appDelegate;
                                   
                                   NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] ;
//                                   =   [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                                   
                                   NSError *error;
                                   
                                   id dat   =   [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   
                                   NSLog(@"eoor %@",error);
                                   
                                   NSLog(@"Dtad %@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
                                   
                                   NSLog(@"Dtad %@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
                                   
                                   NSLog(@"Dtad %@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
                                   
                            
                                   if([parsedData isKindOfClass:[NSDictionary class]])
                                   {
                                       [[Alexa sharedManager].currentUser loadFromDictionary:parsedData];
                                       
                                       [[Alexa sharedManager].currentUser saveCurrentUser];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [strongDelegate setHomeViewController];
                                           
                                       });
                                   }
                               }
                               else {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       UIAlertView  *alertView  =[[ UIAlertView alloc ]initWithTitle:nil message:@"Invalid User" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                                       
                                       [alertView show];
                                       
                                   });
                               }
                           }];
}

@end
