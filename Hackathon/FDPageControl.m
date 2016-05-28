//
//  FDPageControl.m
//  Hackathon
//
//  Created by SHANMUGAM on 07/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "FDPageControl.h"

@interface FDPageControl ()

@property   (nonatomic,assign)  NSInteger   currentPage;
@property   (nonatomic,strong)  NSMutableArray     *views;

@end

@implementation FDPageControl

-(id)initWithNumberOfDots:(NSInteger)dotCount withSpacing:(CGFloat)spacing size:(CGFloat)width {
    self    =   [super init];
    
    if (self) {
        _views  =   [NSMutableArray array];
        
        for (int i=0;i<dotCount;i++) {
            UILabel *dotLabel   =   [UILabel new];
            
            dotLabel.layer.cornerRadius =   width/2.0;
            
            dotLabel.layer.masksToBounds    =   YES;
            
            dotLabel.backgroundColor    =   [UIColor grayColor];
            
            dotLabel.translatesAutoresizingMaskIntoConstraints  =   NO;
            
            [self addSubview:dotLabel];
            
            NSLayoutConstraint  *dotLabelCenterY    =   [NSLayoutConstraint constraintWithItem:dotLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            
            CGFloat offset  = ((i-(dotCount/2)) * spacing) + ((i-(dotCount/2))*(width/2));
            
            NSLayoutConstraint  *dotLabelCenterX    =   [NSLayoutConstraint constraintWithItem:dotLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:offset];
            
            NSLayoutConstraint  *dotLabelWidth    =   [NSLayoutConstraint constraintWithItem:dotLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:width];
            
            NSLayoutConstraint  *dotLabelHeight    =   [NSLayoutConstraint constraintWithItem:dotLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:width];
            
            [self addConstraints:@[dotLabelCenterX,dotLabelCenterY,dotLabelWidth,dotLabelHeight]];
         
            [_views addObject:dotLabel];
        }
    }
    
    return self;
}

-(void)setCurrentSelection:(NSInteger)index
{
    if(_currentPage !=  index)
    {
        UIView  *previousSelectedView   =   (UIView *)_views[_currentPage];
        
        previousSelectedView.backgroundColor    =   [UIColor grayColor];
    }
        
    UIView  *currentView    =   (UIView *)_views[index];
    
    currentView.backgroundColor =   [UIColor greenColor];
    
    _currentPage    =   index;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
