//
//  FDPeopleDetailAnimationController.m
//  Test
//
//  Created by Leo on 07/05/16.
//  Copyright © 2016 Bala. All rights reserved.
//

#import "FDPeopleDetailAnimationController.h"
#import "FDPeopleDetailViewController.h"
#import "PeopleTableViewCell.h"
#import "PeopleViewController.h"

@implementation FDPeopleDetailAnimationController


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    //    UINavigationController *fromNavC =
    PeopleViewController * peopleVC = (PeopleViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FDPeopleDetailViewController *toVC = (FDPeopleDetailViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Create snapshot of the outgoing view.
    PeopleTableViewCell *cell = (PeopleTableViewCell *)[peopleVC.peopleTableView cellForRowAtIndexPath:[peopleVC.peopleTableView indexPathForSelectedRow]];
    UILabel *nameLabel = (UILabel *)[cell.nameLabel snapshotViewAfterScreenUpdates:NO];
    UILabel *designationLabel = (UILabel *)[cell.designationLabel snapshotViewAfterScreenUpdates:NO];
    UILabel *emailLabel = (UILabel *)[cell.emailLabel snapshotViewAfterScreenUpdates:NO];
    UIView *profilePic = [cell.profilePic snapshotViewAfterScreenUpdates:NO];
    
    UIView *outgoingSnapshot = [peopleVC.view snapshotViewAfterScreenUpdates:YES];
    
    UIView *container = [transitionContext containerView];
    // Add the incoming view controller
    [container addSubview:toVC.view];
    
    // Build the animation canvas
    UIView *canvas = [[UIView alloc] initWithFrame:container.bounds];
    canvas.backgroundColor = [UIColor whiteColor];
    [container addSubview:canvas];
    
    [canvas addSubview:outgoingSnapshot];
    [canvas addSubview:nameLabel];
    [canvas addSubview:designationLabel];
    [canvas addSubview:emailLabel];
    [canvas addSubview:profilePic];
    
    // Set the initial frames of the views we're animating
    nameLabel.frame = [container convertRect:cell.nameLabel.bounds fromView:cell.nameLabel];
    designationLabel.frame = [container convertRect:cell.designationLabel.bounds fromView:cell.designationLabel];
    emailLabel.frame = [container convertRect:cell.emailLabel.bounds fromView:cell.emailLabel];
    profilePic.frame = [container convertRect:cell.profilePic.bounds fromView:cell.profilePic];
    
    [UIView animateWithDuration:0.25 animations:^{
        outgoingSnapshot.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            nameLabel.center = toVC.nameLabel.center;
            designationLabel.center = toVC.designationLabel.center;
            emailLabel.center = toVC.emailLabel.center;
            profilePic.center = toVC.profilePic.center;
            
            //            nameLabel.font = toVC.nameLabel.font;
            //            designationLabel.font = toVC.designationLabel.font;
            //            emailLabel.font = toVC.emailLabel.font;
            
            profilePic.transform = CGAffineTransformMakeScale(toVC.profilePic.bounds.size.width / profilePic.bounds.size.width , toVC.profilePic.bounds.size.height / profilePic.bounds.size.height);
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [canvas removeFromSuperview];
        }];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.75;
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
