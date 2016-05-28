
//  PeopleViewController.m
//  Hackathon
//
//  Created by SHANMUGAM on 06/05/16.
//  Copyright © 2016 SHANMUGAM. All rights reserved.
//

#import "PeopleViewController.h"
#import "People.h"
#import "UIImageView+AFNetworking.h"
#import "PeopleTableViewCell.h"
#import "FDPeopleDetailAnimationController.h"
#import "FDPeopleDetailViewController.h"
#import "SVProgressHUD.h"

@interface PeopleViewController ()  <UINavigationControllerDelegate, UISearchDisplayDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, PeopleTableViewCellDelegate> {
    NSMutableArray *peoples;
    NSArray *searchedPeopleList;
    
    int currentPage;
}
@property (nonatomic, retain) NSTimer *searchTimer;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor redColor];
    [SVProgressHUD show];
    currentPage = 1;
 
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.peopleTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.scopeButtonTitles = [NSArray array];
    self.searchController.searchBar.showsScopeBar = NO;
    [self.searchController.searchBar sizeToFit];

//    _peopleTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self fetchMore];
}

- (void)fetchMore {
    NSLog(@"Fetching more");
    [People fetchPeopleList:currentPage withCompletion:^(NSArray *peopleList, NSError *error) {
        
        if (!error) {
            [SVProgressHUD dismiss];
            NSLog(@"peopleList = %@", peopleList);
            if (currentPage == 1) {
                peoples = [NSMutableArray arrayWithArray:peopleList];
            } else {
                [peoples addObjectsFromArray:peopleList];
            }
            currentPage++;
            [_peopleTableView reloadData];
        } else {
#warning uncomment this....
//            [SVProgressHUD showErrorWithStatus:error.description];
            
        }
    }];
}

- (IBAction)refreshPeopleList:(id)sender {
    
    [SVProgressHUD show];
    currentPage = 1;
    [self fetchMore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 44; //I used the 44, the height of SearchBar
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
        return searchedPeopleList.count;
    }
    return peoples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"peopleCell";
    PeopleTableViewCell *cell = [self.peopleTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    BOOL isSearchActive = _searchController.active && ![_searchController.searchBar.text isEqualToString:@""];
    People *people = isSearchActive ? searchedPeopleList[indexPath.row] : peoples[indexPath.row];
    
    cell.people = people;
    cell.nameLabel.text = people.name?: @"" ;
    cell.emailLabel.text = people.emailID?: @"" ;
    cell.designationLabel.text = people.designation?: @"";
    cell.profilePic.image = nil;
    cell.delegate = self;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:people.picURL]];
    [cell.profilePic setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        people.profileImage = image;
        cell.profilePic.image = [self circleImage:image forImageView:cell.profilePic withCornerRadius:25.0];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == peoples.count - 1) {
        [self fetchMore];
    }
}

- (void)callPeople:(People *)people {
    
    if (people.phone.length) {
        [self callNumber:people.phone];
    }
}

- (BOOL)validatePhone:(NSString *)phoneNumber {
    
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

// Make it async...
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

- (void)callNumber:(NSString *)phoneNumber {
    
    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumber]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    
    if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
        [UIApplication.sharedApplication openURL:phoneUrl];
    } else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
        [UIApplication.sharedApplication openURL:phoneFallbackUrl];
    } else {
        // Show an error message: Your device can not do phone calls.
    }

}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [FDPeopleDetailAnimationController new];
    }
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // Get reference to the destination view controller
        FDPeopleDetailViewController *vc = [segue destinationViewController];
        BOOL isSearchActive = _searchController.active && ![_searchController.searchBar.text isEqualToString:@""];
        People *people = isSearchActive ? searchedPeopleList[_peopleTableView.indexPathForSelectedRow.row] : peoples[_peopleTableView.indexPathForSelectedRow.row];
        
        vc.people = people;
    }
}

#pragma mark - Search Delegates

- (void)searchForPeople {
    
    searchedPeopleList = nil; // Clear the filtered array.
    [SVProgressHUD show];
    NSString *searchText = _searchController.searchBar.text;
    
    if (searchText.length > 2) {
        [People searchPeople:searchText withCompletion:^(NSArray *peoplesList, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description];
            }
            searchedPeopleList = peoplesList;
            [_peopleTableView reloadData];
        }];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if (self.searchTimer) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(searchForPeople) userInfo:nil repeats:FALSE];
}

#pragma mark - PeopleCall

- (void)tappedCallButtonPeople:(People *)people {
    [self callPeople:people];
}
@end
