//
//  DotViews.m
//  Hackathon
//
//  Created by SHANMUGAM on 08/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "DotViews.h"
#define ARC4RANDOM_MAX      0x100000000


@interface DotViews ()
{
    UIView *views[10];
    CGFloat duration[10],currentTime[10];
    NSTimer *timer;
}
@end

@implementation DotViews

-(id)initWithDotCount:(NSInteger)count
{
    self    =   [super init];
    
    if(self)
    {
        for(int i=0;i<count;i++)
        {
            double val = ((double)arc4random() / ARC4RANDOM_MAX);
            
            double val1 = ((double)arc4random() / ARC4RANDOM_MAX);
            
            double val2 = ((double)arc4random() / ARC4RANDOM_MAX);
            
            UIView  *view   =   [UIView new];
            view.frame      =   CGRectMake(0, 0, 10, 10);
            view.layer.cornerRadius     =   5.0;
            view.layer.masksToBounds    =   YES;
            view.backgroundColor        =   [UIColor colorWithRed:val green:val1 blue:val2 alpha:1.0];
            
            views[i]        =   view;
            
            duration[i]     =   2.0 + (0.25*i);
            
            currentTime[i]  =   0;
            
            [self addSubview:view];
        }
    }
    
    return self;
}

-(void)animateViews
{
    timer  =   [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animateTimer) userInfo:nil repeats:YES];
    
    [timer fire];
}

-(void)animateTimer
{
    for(int i=0;i<10;i++)
    {
        UIView  *view   =   views[i];
        
        currentTime[i]+=0.01;
        
        CGFloat x   =   [self getOffsetX:currentTime[i] start:0 end:self.frame.size.width duration:duration[i]];
        
        view.frame  =   CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
}

-(void)finishAnimation
{
    [timer invalidate];
    
    timer  =   [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animateTimer) userInfo:nil repeats:YES];
    
    [timer fire];
}

-(CGFloat)getOffsetX:(CGFloat)currentTime start:(CGFloat)start end:(CGFloat)end duration:(CGFloat)duration
{
    currentTime /=duration;
    
    return end*currentTime*currentTime+start;
}

@end
