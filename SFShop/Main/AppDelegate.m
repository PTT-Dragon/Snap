//
//  AppDelegate.m
//  SFShop
//
//  Created by MasterFly on 2021/9/22.
//

#import "AppDelegate.h"
#import "MainTabViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabViewController *tab = [[MainTabViewController alloc] init];
    tab.viewControllers = @[UIViewController.new,UIViewController.new];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
