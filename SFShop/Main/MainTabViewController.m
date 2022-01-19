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
#import "PublicWebViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    BaseNavigationController *accountNav = [[BaseNavigationController alloc]initWithRootViewController:accountVC];
    accountNav.tabBarItem.title = kLocalizedString(@"Account");
    accountNav.tabBarItem.image = [UIImage imageNamed:@"account_tab_icon"];
    PublicWebViewController *homeVc = [[PublicWebViewController alloc] init];
    homeVc.isHome = YES;
    BaseNavigationController *homeNav = [[BaseNavigationController alloc]initWithRootViewController:homeVc];
    homeVc.url = [NSString stringWithFormat:@"%@/main/home",Host];
//    homeVc.navigationController.navigationBar.hidden = YES;
//    homeNav.navigationBar.hidden = YES;
    homeNav.tabBarItem.title = kLocalizedString(@"Home");
    homeNav.tabBarItem.image = [UIImage imageNamed:@"home_tab_icon"];
    CartViewController *cartVC = [[CartViewController alloc] init];
    cartVC.tabBarItem.title = kLocalizedString(@"Cart");
    cartVC.tabBarItem.image = [UIImage imageNamed:@"cart_tab_icon"];
    BaseNavigationController *CartNav = [[BaseNavigationController alloc]initWithRootViewController:cartVC];
    CommunityViewController *communityVC = [[CommunityViewController alloc] init];
    BaseNavigationController *communityNav = [[BaseNavigationController alloc]initWithRootViewController:communityVC];
    communityNav.tabBarItem.title = kLocalizedString(@"Community");
    communityNav.tabBarItem.image = [UIImage imageNamed:@"community_tab_icon"];
    
    //分类
    CategoryViewController *categoryVc = [[CategoryViewController alloc] init];
    BaseNavigationController *categoryNav = [[BaseNavigationController alloc]initWithRootViewController:categoryVc];
    categoryNav.tabBarItem.title = kLocalizedString(@"Category");
    categoryNav.tabBarItem.image = [UIImage imageNamed:@"category_tab_icon"];
    
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self setViewControllers:@[homeNav,categoryNav,communityNav,CartNav,accountNav]];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:kLocalizedString(@"Cart")]) {
        [baseTool updateCartNum];
    }
}
@end
