//
//  ViewController.m
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "ViewController.h"

#import "Constants.h"

#import <GoogleSignIn/GoogleSignIn.h>

#import "AppDelegate.h"

@interface ViewController ()<GIDSignInUIDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor   =   UIColorFromRGB(0XFBFBFB);
    
    UIImageView *appLogo    =   [[UIImageView alloc]init];
    
    appLogo.translatesAutoresizingMaskIntoConstraints   =   NO;
    
//    appLogo.contentMode     =   UIViewContentModeCenter;
    
    appLogo.image   =   [[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    appLogo.tintColor   =   UIColorFromRGB(0X4BAF98);
    
    [self.view addSubview:appLogo];
    
    UIButton    *signInWithGoogle   =   [UIButton buttonWithType:UIButtonTypeCustom];
    
    signInWithGoogle.translatesAutoresizingMaskIntoConstraints  =   NO;
    
    signInWithGoogle.imageView.contentMode  =   UIViewContentModeCenter;
    
    signInWithGoogle.backgroundColor    =   [UIColor whiteColor];
    
    [signInWithGoogle setTitle:@"Sign in with Google" forState:UIControlStateNormal];
    
    [signInWithGoogle setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    
    [signInWithGoogle setTitleColor:UIColorFromRGB(0X625F5C) forState:UIControlStateNormal];
    
    [signInWithGoogle addTarget:self action:@selector(siginInTriggerd) forControlEvents:UIControlEventTouchUpInside];
    
    signInWithGoogle.layer.cornerRadius = 4.0f;

    signInWithGoogle.layer.masksToBounds = NO;

    signInWithGoogle.layer.shadowColor = [UIColor blackColor].CGColor;
    
    signInWithGoogle.layer.shadowOpacity = 0.5;
    
    signInWithGoogle.layer.shadowRadius = 3.0;
    
    signInWithGoogle.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);

    [signInWithGoogle setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    [signInWithGoogle setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [self.view addSubview:signInWithGoogle];
    
    NSLayoutConstraint  *appLogoBottom     =   [NSLayoutConstraint constraintWithItem:appLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-30.0];
    
    NSLayoutConstraint  *appLogoCenterX     =   [NSLayoutConstraint constraintWithItem:appLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *appLogoWidth     =   [NSLayoutConstraint constraintWithItem:appLogo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:128];
    
    NSLayoutConstraint  *appLogoHeight     =   [NSLayoutConstraint constraintWithItem:appLogo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:128];
    
    [self.view addConstraints:@[appLogoBottom,appLogoCenterX,appLogoWidth,appLogoHeight]];
    
    NSLayoutConstraint  *signInWithGoogleCenterX     =   [NSLayoutConstraint constraintWithItem:signInWithGoogle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *signInWithGoogleTop     =   [NSLayoutConstraint constraintWithItem:signInWithGoogle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:15.0];
    
    CGFloat width   =   [signInWithGoogle.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}].width;
    
    CGFloat imageWidth  =   CGImageGetWidth(signInWithGoogle.imageView.image.CGImage);
    
    width   +=   imageWidth;
    
    width   +=   25;
    
    CGFloat height = 0;
    
    CGFloat imageHeight =   CGImageGetHeight(signInWithGoogle.imageView.image.CGImage);
    
    height   +=   imageHeight;
    
    height   +=   0;
    
    NSLayoutConstraint  *signInWithGoogleWidth  =   [NSLayoutConstraint constraintWithItem:signInWithGoogle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:width];
    
     NSLayoutConstraint  *signInWithGoogleHeight  =   [NSLayoutConstraint constraintWithItem:signInWithGoogle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:height];
    
    [self.view addConstraints:@[signInWithGoogleCenterX,signInWithGoogleTop,signInWithGoogleWidth,signInWithGoogleHeight]];
    
    [GIDSignIn sharedInstance].uiDelegate   =   self;
}

-(void)siginInTriggerd
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    [GIDSignIn sharedInstance].delegate =   delegate;

    [[GIDSignIn sharedInstance] signOut];
    
    [[GIDSignIn sharedInstance] signIn];
}

-(void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
