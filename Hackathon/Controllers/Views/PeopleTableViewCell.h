//
//  PeopleTableViewCell.h
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import <UIKit/UIKit.h>
@class People;
@protocol PeopleTableViewCellDelegate <NSObject>

- (void)tappedCallButtonPeople:(People *)people;

@end

@interface PeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *designationLabel;
@property (weak, nonatomic) People *people;
@property (weak, nonatomic) id <PeopleTableViewCellDelegate> delegate;

@end
