//
//  MainTabViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/9/22.
//

#import "MainTabViewController.h"
#import "AccountViewController.h"
#import "HomeViewController.h"
#import "CartViewController.h"
#import "CommunityViewController.h"
#import "BaseNavigationController.h"
#import "CategoryViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    BaseNavigationController *accountNav = [[BaseNavigationController alloc]initWithRootViewController:accountVC];
    accountNav.tabBarItem.title = @"Account";
    accountNav.tabBarItem.image = [UIImage imageNamed:@"account_tab_icon"];
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem.title = @"Home";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"home_tab_icon"];
    CartViewController *cartVC = [[CartViewController alloc] init];
    cartVC.tabBarItem.title = @"Cart";
    cartVC.tabBarItem.image = [UIImage imageNamed:@"cart_tab_icon"];
    BaseNavigationController *CartNav = [[BaseNavigationController alloc]initWithRootViewController:cartVC];
    CommunityViewController *communityVC = [[CommunityViewController alloc] init];
    BaseNavigationController *communityNav = [[BaseNavigationController alloc]initWithRootViewController:communityVC];
    communityNav.tabBarItem.title = @"Community";
    communityNav.tabBarItem.image = [UIImage imageNamed:@"community_tab_icon"];
    
    //分类
    CategoryViewController *categoryVc = [[CategoryViewController alloc] init];
    BaseNavigationController *categoryNav = [[BaseNavigationController alloc]initWithRootViewController:categoryVc];
    categoryNav.tabBarItem.title = @"Category";
    categoryNav.tabBarItem.image = [UIImage imageNamed:@"category_tab_icon"];
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self setViewControllers:@[homeVC,categoryNav,communityNav,CartNav,accountNav]];
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
