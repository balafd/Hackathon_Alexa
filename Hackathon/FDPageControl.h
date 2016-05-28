//
//  FDPageControl.h
//  Hackathon
//
//  Created by SHANMUGAM on 07/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDPageControl : UIView

-(id)initWithNumberOfDots:(NSInteger)dotCount withSpacing:(CGFloat)spacing size:(CGFloat)width;

-(void)setCurrentSelection:(NSInteger)index;

@end
