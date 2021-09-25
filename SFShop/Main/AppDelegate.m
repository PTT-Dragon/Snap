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

    //网络请求demo
    [self netDemo];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabViewController *tab = [[MainTabViewController alloc] init];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)netDemo {
    //网络请求demo
    //ps: 新增url 参照SFNetworkH5Module (如果是新模块需要创建module 文件,并在 SFNetworkURL 中添加模块属性)
//    [SFNetworkManager get:SFNet.h5.time success:^(id response) {
//        NSLog(@"");
//    } failed:^(NSError * _Nonnull error) {
//        NSLog(@"");
//    }];
}

@end
