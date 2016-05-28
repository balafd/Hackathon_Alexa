//
//  PeopleTableViewCell.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "PeopleTableViewCell.h"

@implementation PeopleTableViewCell

- (IBAction)callButtonTapped:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(tappedCallButtonPeople:)]) {
        [_delegate tappedCallButtonPeople:_people];
    }
}

@end
