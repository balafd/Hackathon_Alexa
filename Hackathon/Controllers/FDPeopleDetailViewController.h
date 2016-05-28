//
//  FDPeopleDetailViewController.h
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"


@interface FDPeopleDetailViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *designationLabel;
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;
@property (retain, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel *managerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (retain, nonatomic) IBOutlet UIImageView *profilePic;

@property (nonatomic, strong) People *people;

@property (readwrite, nonatomic) CGPoint origin;

@end

