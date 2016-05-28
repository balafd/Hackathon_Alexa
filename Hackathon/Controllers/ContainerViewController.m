//
//  ContainerViewController.m
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "ContainerViewController.h"
#import "SearchViewController.h"
#import "EventViewController.h"
#import "PeopleViewController.h"


@interface ContainerViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

{
    NSInteger   viewControllerIndex;
    
    NSInteger   childViewControllersCount;
}

@property   (nonatomic,strong)  SearchViewController    *searchViewController;

@property   (nonatomic,strong)  EventViewController     *eventViewController;

@property   (nonatomic,strong)  PeopleViewController    *peopleViewController;
@property   (nonatomic,strong)  UINavigationController    *peopleNavigationViewController;

@end

@implementation ContainerViewController

- (id)init {
    self = [super init];
    
    if (self) {
        childViewControllersCount   =   3;
        viewControllerIndex         =   1;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initViewControllers];
    
    [self constructPageViewController];
    
    [self constructPageControl];
}

- (void)initViewControllers {
    
    _searchViewController = [[SearchViewController alloc] init];
    
    _eventViewController = [[EventViewController alloc] init];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _peopleNavigationViewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"PeopleNavController"];
}


- (void)constructPageControl {
    _pageControl    =   [[FDPageControl alloc]initWithNumberOfDots:childViewControllersCount withSpacing:40.0 size:5.0];
    
//    _pageControl.translatesAutoresizingMaskIntoConstraints  =   NO;
    
//    _pageControl.autoresizingMask   =   UIViewAutoresizingFlexibleWidth;
    
    _pageControl.frame  =   CGRectMake(0,0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    
    [_pageControl setCurrentSelection:viewControllerIndex];
    
//    _pageControl    =   [[UIPageControl alloc]initWithFrame:CGRectMake(0,0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    
//    _pageControl.currentPageIndicatorTintColor          =   [UIColor greenColor];

    _pageControl.backgroundColor    =   [UIColor clearColor];
    
//    [_pageControl setNumberOfPages:childViewControllersCount];
    
//    [_pageControl setCurrentPage:viewControllerIndex];
    
    [self.navigationController.navigationBar addSubview: _pageControl];
    
//    [self.view addSubview:_pageControl];
//    
//    NSLayoutConstraint  *pageControlLeft    =   [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
// 
//    NSLayoutConstraint  *pageControlRight    =   [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint  *pageControlTop    =   [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint  *pageControlHeight    =   [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:60];
//    
//    [self.view addConstraints:@[pageControlLeft,pageControlRight,pageControlTop,pageControlHeight]];
}

- (void)constructPageViewController {
    UIPageViewController *pageViewController=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate=self;
    pageViewController.dataSource=self;
    
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    [self.view addSubview:pageViewController.view];
    
    [pageViewController setViewControllers:@[[self viewControllerAtIndex:viewControllerIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    
    }];
    
    pageViewController.view.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSDictionary *views = @{@"pageView":pageViewController.view};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|" options:0 metrics:nil views:views]];
    
    NSLayoutConstraint *pageViewControllerTop=[NSLayoutConstraint constraintWithItem:pageViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *pageViewControllerBottom=[NSLayoutConstraint constraintWithItem:pageViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *pageViewControllerLeft=[NSLayoutConstraint constraintWithItem:pageViewController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint *pageViewControllerRight=[NSLayoutConstraint constraintWithItem:pageViewController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[pageViewControllerLeft,pageViewControllerRight,pageViewControllerTop,pageViewControllerBottom]];
    
    _containerPageViewController = pageViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    viewControllerIndex=viewController.view.tag;
    
    if(viewControllerIndex-1>=0)
    {
        viewControllerIndex--;
        return [self viewControllerAtIndex:viewControllerIndex];
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    viewControllerIndex=viewController.view.tag;
    if(viewControllerIndex+1<childViewControllersCount)
    {
        viewControllerIndex++;
        return [self viewControllerAtIndex:viewControllerIndex];
    }
    
    return nil;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *viewcontroller = [pageViewController viewControllers].firstObject;
        NSInteger   controllerIndex = viewcontroller.view.tag;
        [self.pageControl setCurrentSelection:controllerIndex];
    }
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    
    if (index == 0) {
        _peopleNavigationViewController.view.tag = index;
        
//        _peopleViewController.view.tag =   index;
        return _peopleNavigationViewController;
    } else if (index == 1) {
        
        _searchViewController.view.tag =   index;
        return _searchViewController;
    } else if (index == 2) {
        
        _eventViewController.view.tag =   index;
        return _eventViewController;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
