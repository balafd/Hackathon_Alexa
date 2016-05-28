//
//  SearchViewController.m
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "SearchViewController.h"
#import "Constants.h"
#import "Search.h"
#import "DotViews.h"

#define searchBarContainerTopOffsetOnRest        200

#define searchBarContainerTopOffsetOnAction      50

#define searchBarContainerWidthOnRest            80

#define searBarContainerWidthOnAction            20

#define searchBarWidthOnRest                     0

#define searBarContainerHeight                   50

#define listViewCellheight                       40

#define webViewTotalHeight                       100

#define webViewTotalWidth                        80

static NSString * const kSearchViewCellIdentifier = @"SEARCHVIEWCELL";

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property   (nonatomic,strong)  UIView      *searchBarContainer;

@property   (nonatomic,strong)  UIView      *searchBarContainerLayer;

@property   (nonatomic,strong)  UITextField *searchBar;

@property   (nonatomic,strong)  UIButton    *cancel;

@property   (nonatomic,strong)  UITableView *resultsListView;

@property   (nonatomic,strong)  NSArray *menu;

@property   (nonatomic,strong)  NSMutableArray *result;

@property   (nonatomic,strong)  NSLayoutConstraint  *searchBarContainerTop,*searchBarContainerWidth,*searchBarContainerHeight,*searchBarWidth,*listHeight,*webViewWidth,*webViewCenterX,*webViewHeight,*webViewCenterY;

@property   (nonatomic,strong)  UIWebView   *webView;

@property   (nonatomic,strong)  DotViews    *dotView;

@end

@implementation SearchViewController

-(id)init
{
    self    =   [super init];
    if(self)
    {
        _menu   =   @[@"Freshdesk",@"Freshsales",@"Abc",@"Fresh",@"Abdc",@"Google",@"Facebook",@"Facebook1",@"Facebook2",@"Facebook3",@"Facebook4",@"Facebook5",@"Facebook6"];
        
        _result =   [NSMutableArray array];
    }
    return self;
}

-(void)loadView
{
    [super loadView];

    _searchBarContainer =   [UIView new];
    _searchBarContainer.translatesAutoresizingMaskIntoConstraints   =   NO;
    _searchBarContainer.layer.cornerRadius = 2.0f;
    _searchBarContainer.layer.masksToBounds = NO;
    _searchBarContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    _searchBarContainer.layer.shadowOpacity = 0.5;
    _searchBarContainer.layer.shadowRadius = 1.0;
    _searchBarContainer.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    
    _searchBarContainerLayer    =   [UIView new];
    _searchBarContainerLayer.translatesAutoresizingMaskIntoConstraints  =   NO;
    _searchBarContainerLayer.backgroundColor    =   UIColorFromRGB(0X333333);
    _searchBarContainerLayer.hidden =   YES;

    _searchBar  =   [[UITextField alloc]init];
    _searchBar.translatesAutoresizingMaskIntoConstraints    =   NO;
    _searchBar.clearButtonMode  =   UITextFieldViewModeWhileEditing;
    _searchBar.backgroundColor  =   [UIColor whiteColor];
    _searchBar.delegate         =   self;
    _searchBar.leftView         =   [self leftView:NO];
    _searchBar.leftViewMode     =   UITextFieldViewModeAlways;
    _searchBar.returnKeyType = UIReturnKeySearch;
    
    _cancel     =   [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.translatesAutoresizingMaskIntoConstraints   =   NO;
    [_cancel setTitle:@"SEARCH" forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_cancel setBackgroundColor:[UIColor whiteColor]];
    _cancel.titleLabel.font =   [UIFont systemFontOfSize:14.0];
    [_cancel setTitleColor:UIColorFromRGB(0X747474) forState:UIControlStateNormal];
    [_cancel setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_cancel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [self.view addSubview:_searchBarContainer];
    [self.searchBarContainer addSubview:_cancel];
    [self.searchBarContainer addSubview:_searchBar];
    [self.view addSubview:_searchBarContainerLayer];
    
    _searchBarContainerTop   =   [NSLayoutConstraint constraintWithItem:self.searchBarContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:searchBarContainerTopOffsetOnRest];
    
    NSLayoutConstraint  *searchBarContainerCenterX   =   [NSLayoutConstraint constraintWithItem:self.searchBarContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    _searchBarContainerWidth =   [NSLayoutConstraint constraintWithItem:self.searchBarContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-searchBarContainerWidthOnRest];
    
    _searchBarContainerHeight =   [NSLayoutConstraint constraintWithItem:self.searchBarContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:searBarContainerHeight];

    
    [self.view addConstraints:@[_searchBarContainerTop,searchBarContainerCenterX,_searchBarContainerWidth,_searchBarContainerHeight]];
    
    NSLayoutConstraint  *layerLeft  =   [NSLayoutConstraint constraintWithItem:self.searchBarContainerLayer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *layerRigt  =   [NSLayoutConstraint constraintWithItem:self.searchBarContainerLayer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *layerTop  =   [NSLayoutConstraint constraintWithItem:self.searchBarContainerLayer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *layerHeight  =   [NSLayoutConstraint constraintWithItem:self.searchBarContainerLayer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:1.0];
    
    [self.view addConstraints:@[layerLeft,layerRigt,layerTop,layerHeight]];
    
    NSLayoutConstraint  *searchBarLeft  =   [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *searchBarTop  =   [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *searchBarBottom  =   [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    _searchBarWidth  =   [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    [self.searchBarContainer addConstraints:@[searchBarLeft,searchBarTop,searchBarBottom,_searchBarWidth]];
    
    NSLayoutConstraint  *cancelRight    =   [NSLayoutConstraint constraintWithItem:self.cancel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
     NSLayoutConstraint  *cancelHeight    =   [NSLayoutConstraint constraintWithItem:self.cancel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *cancelCenterY    =   [NSLayoutConstraint constraintWithItem:self.cancel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    CGFloat cancelTitle =   [self.cancel.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}].width + 20;
    
    NSLayoutConstraint  *cancelWidth    =   [NSLayoutConstraint constraintWithItem:self.cancel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cancelTitle];
    
    [self.view addConstraints:@[cancelRight,cancelCenterY,cancelWidth,cancelHeight]];
    
}

-(void)setBorderForSearchBar:(BOOL)status
{

}

-(UIView *)leftView:(BOOL)edit
{
    if(edit)
    {
        UIView  *leftView           =   [UIView new];
        leftView.backgroundColor    =   [UIColor whiteColor];
        leftView.frame              =   CGRectMake(0, 0, 20,searBarContainerHeight);
        return leftView;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor   =   UIColorFromRGB(0XF2F2F2);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChanged:) name:UIKeyboardWillHideNotification object:nil];
    
    [self constructResultsListView];
    
    [self initWebView];
    
    // Do any additional setup after loading the view.
}

-(void)initWebView
{
    _webView    =   [[UIWebView alloc]init];
    
    _webView.translatesAutoresizingMaskIntoConstraints  =   NO;
    
    _webView.delegate   =   self;
    
    _webView.hidden =   YES;
    
    _webView.backgroundColor    =   [UIColor whiteColor];
    
    _webView.layer.cornerRadius = 2.0f;
    _webView.layer.masksToBounds = NO;
    _webView.layer.shadowColor = [UIColor blackColor].CGColor;
    _webView.layer.shadowOpacity = 0.5;
    _webView.layer.shadowRadius = 1.0;
    _webView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);

    
    [self.view addSubview:_webView];
    
    _webViewCenterX    =   [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    _webViewWidth       =   [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    _webViewHeight         =   [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeHeight multiplier:2.5 constant:0];
    
    _webViewCenterY      =   [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50];
    
    [self.view addConstraints:@[_webViewCenterX,_webViewCenterY,_webViewWidth,_webViewHeight]];
}

-(void)constructResultsListView
{
  /*  _resultsListView    =   [[UITableView alloc]init];
    _resultsListView.translatesAutoresizingMaskIntoConstraints  =   NO;
    _resultsListView.delegate   =   self;
    _resultsListView.dataSource =   self;
    
    [_resultsListView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSearchViewCellIdentifier];*/
}

- (void)cancelButtonClicked
{
    _searchBar.text =   nil;
    _searchBar.leftView =   [self leftView:NO];
    
    [_searchBar resignFirstResponder];
    
//    if(!_searchBar.text.length)
//    {
//        return;
//    }
//    
//    [Search getSearchResult:_searchBar.text resultBlock:^(NSDictionary *dictionary) {
//        
//        NSArray     *array  =   dictionary[@"Outcome"];
//        
//        NSDictionary    *htmlContent    =   array.firstObject;
//        
//        [self loadWebViewContent:htmlContent[@"Response"]];
//        
//    }];
//
//    [self startLoader];
}

- (void)searchAlexaForText:(NSString *)searchText {
    
    if (!searchText.length) {
        return;
    }
    [Search getSearchResult:searchText resultBlock:^(NSDictionary *dictionary) {
        
        NSArray *array = dictionary[@"Outcome"];
        NSDictionary *htmlContent = array.firstObject;
        [self loadWebViewContent:htmlContent[@"Response"]];
    }];
    
    [self startLoader];
}

- (void)startLoader {
    
    DotViews *dotViews = [[DotViews alloc] initWithDotCount:10];
    dotViews.frame = CGRectMake(0, 200, 300, 20);
    [self.view addSubview:dotViews];
    [dotViews animateViews];
    _dotView = dotViews;
}

- (void)setSearchResultsConstraints {
    
    NSLayoutConstraint  *listLeft   =   [NSLayoutConstraint constraintWithItem:self.resultsListView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *listRight  =   [NSLayoutConstraint constraintWithItem:self.resultsListView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainer attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint  *listTop    =   [NSLayoutConstraint constraintWithItem:self.resultsListView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBarContainerLayer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    _listHeight =   [NSLayoutConstraint constraintWithItem:self.resultsListView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:0];
    
    [self.view addConstraints:@[listLeft,listRight,listTop,_listHeight]];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(CGFloat)listViewHeight
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)?([_result count]>5?5:[_result count])*listViewCellheight:2*listViewCellheight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_result count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return listViewCellheight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *dummyView = [UIView new];
    
    dummyView.backgroundColor   =   [UIColor blackColor];
    
    return dummyView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell   =   [tableView dequeueReusableCellWithIdentifier:kSearchViewCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text =   _result[indexPath.row];
    
    return cell;
}


-(void)keyBoardWillAppear:(NSNotification *)notification
{
    NSTimeInterval duartion    =   [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self animateTextField:YES timeInterval:duartion];
}

-(void)statusBarOrientationChanged:(NSNotification *)notification
{
    
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    NSTimeInterval duartion    =   [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self animateTextField:NO timeInterval:duartion];

    [self leftView:NO];
}


#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.leftView  =   [self leftView:YES];
    textField.placeholder   =   @"Search";
    _searchEnabled  =   YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    [self processText:string];

    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text          =   nil;
    textField.leftView      =   [self leftView:NO];
    textField.placeholder   =   nil;
    _searchEnabled          =   NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    _searchBar.text =   nil;
    _searchBar.leftView =   [self leftView:NO];
    [_searchBar resignFirstResponder];
    
    return YES;
}

-(void)loadWebViewContent:(NSString *)content
{
    [_webView loadHTMLString:content baseURL:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!webView.hidden)
        return;
    
    [_dotView finishAnimation];
    
    webView.hidden  =   NO;
    
    _webViewWidth.constant  =  - 150;
    
    _webViewHeight.constant =   -  70;
    
    [self.view layoutIfNeeded];
    
    _webViewWidth.constant  =  0;
    
    _webViewHeight.constant =   0;
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

-(void)dismissWebViewIfExists
{
    if(!_webView.hidden )
    {
    
    _webViewCenterX.constant    =   -self.view.frame.size.width;
    
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
       
        _webView.hidden =   YES;
        
        _webViewCenterX.constant    =   0;
        
        [self.view layoutIfNeeded];
        
    }];
    }
}

- (void)processText:(NSString *)string {
    [_result removeAllObjects];
    
    
    
    
    [self.menu enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString    *temp   =   obj;
        
        if([temp containsString:string])
        {
            [_result addObject:temp];
        }
        
    }];
    
    [CATransaction begin];
    
    [_resultsListView reloadData];
    
    [CATransaction setCompletionBlock:^{
       
//        [self insertListView:NO];
        
    }];
    
    [CATransaction commit];
}

-(void)animateTextField:(BOOL)anim timeInterval:(NSTimeInterval)interval
{
    if(anim)
    {
        [self dismissWebViewIfExists];
        
        [self performSelector:@selector(animTextField:) withObject:[NSNumber numberWithDouble:interval] afterDelay:0.11];
    }
    else
    {
//        [self resetListView];
        
        _searchBarContainerWidth.constant    =   -searchBarContainerWidthOnRest;
        _searchBarContainerTop.constant      =   searchBarContainerTopOffsetOnRest;
        _searchBarWidth.constant             =   0;
        
        [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

-(void)animTextField:(NSNumber *)interval
{
    _searchBarWidth.constant             =  -_cancel.frame.size.width;
    
    [UIView animateWithDuration:0.01 animations:^{
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if(finished)
        {
            
            
        }
    }];
    
    _searchBarContainerWidth.constant    =  - searBarContainerWidthOnAction;
    _searchBarContainerTop.constant      =   searchBarContainerTopOffsetOnAction;
    
    [UIView animateWithDuration:[interval doubleValue] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        
        //            [self insertListView:YES];
        
    }];
}

-(void)insertListView:(BOOL)initial
{
    if(initial)
    {
        [self.view addSubview:self.resultsListView];
        [self setSearchResultsConstraints];
    }
    
    [_result count]?[self.searchBarContainerLayer setHidden:NO]:[self.searchBarContainerLayer setHidden:YES];
    
    _listHeight.constant    =   [self listViewHeight];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
}

-(void)resetListView
{
    [self.resultsListView removeFromSuperview];
    
    self.searchBarContainerLayer.hidden    =   YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
