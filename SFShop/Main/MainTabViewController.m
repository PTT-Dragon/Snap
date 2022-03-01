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
    if(@available(iOS 15.0,*)){
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance;
        }
        if(@available(iOS 15.0,*)){
            UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
            appearance.backgroundImage = [UIImage imageNamed:@"tab-bar-background"];
            self.tabBar.scrollEdgeAppearance = appearance;
        }
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
    cartVC.isTab = YES;
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
    self.tabBar.tintColor = RGBColorFrom16(0xFF1659);
    [self setViewControllers:@[homeNav,categoryNav,communityNav,CartNav,accountNav]];
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
    [baseTool updateCartNum];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 1)];
//    line.backgroundColor = [UIColor blackColor];
//    [self.tabBar addSubview:line];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:kLocalizedString(@"Cart")]) {
        [baseTool updateCartNum];
    }else if ([item.title isEqualToString:kLocalizedString(@"Home")]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KReloadWebview" object:nil];
    }
}
@end
