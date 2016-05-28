//
//  FDPeopleDetailViewController.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "FDPeopleDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@implementation FDPeopleDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _nameLabel.text = _people.name;
    _designationLabel.text = _people.designation;
    _emailLabel.text = _people.emailID;
    _teamLabel.text = _people.team;
    _managerNameLabel.text = _people.manager;
    _phoneLabel.text = _people.phone;
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_people.picURL]];
    
    [_profilePic setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        //        _people.profileImage = image;
        self.profilePic.image = [self circleImage:image forImageView:self.profilePic withCornerRadius:75.0];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    }];
    
    [SVProgressHUD show];
    [People getPeoplePlaceDetail:_people withCompletion:^(People *people, NSError *error) {
        
        _currentStatusLabel.text = _people.currentStatus;
        [SVProgressHUD dismiss];
    }];
    
}

- (UIImage *)circleImage:(UIImage *)imageToBeCircled forImageView:(UIImageView *)imageView withCornerRadius:(CGFloat)cornerRadius {
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [imageToBeCircled drawInRect:imageView.bounds];
    
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 0.1;
    imageView.layer.shadowOffset = CGSizeMake(1, 1);
    imageView.layer.shadowRadius = 1;
    imageView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                                            cornerRadius:cornerRadius].CGPath;
    imageView.layer.shouldRasterize = YES;
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
