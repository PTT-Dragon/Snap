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


@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    UINavigationController *tabNav = [[ UINavigationController alloc]initWithRootViewController:accountVC];
    tabNav.tabBarItem.title = @"Account";
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem.title = @"Home";
    CartViewController *cartVC = [[CartViewController alloc] init];
    cartVC.tabBarItem.title = @"Cart";
    CommunityViewController *CommunityVC = [[CommunityViewController alloc] init];
    CommunityVC.tabBarItem.title = @"Community";
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self setViewControllers:@[homeVC,CommunityVC,cartVC,tabNav]];
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
