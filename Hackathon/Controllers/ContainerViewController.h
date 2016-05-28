//
//  ContainerViewController.h
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPageControl.h"

@interface ContainerViewController : UIViewController

@property   (nonatomic,strong)  UIPageViewController    *containerPageViewController;

@property   (nonatomic,strong)  FDPageControl           *pageControl;

@end
