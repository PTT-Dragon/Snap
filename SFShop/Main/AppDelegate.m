//
//  AppDelegate.m
//  SFShop
//
//  Created by MasterFly on 2021/9/22.
//

#import "AppDelegate.h"
#import "MainTabViewController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //网络请求demo
    [self netDemo];
    [self initUmeng];
    [self confitUShareSettings];
    [self configUSharePlatforms];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    MainTabViewController *tab = [[MainTabViewController alloc] init];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLanguageChangeNotification:)
                                                 name:@"KLanguageChange"
                                               object:nil];
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

- (void)receiveLanguageChangeNotification:(NSNotification *)sender {
    [MBProgressHUD autoDismissShowHudMsg:@"切换中" andDismissDuration:3];
    
    MainTabViewController *tab = [[MainTabViewController alloc] init];
    self.window.rootViewController = tab;
}

-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url {
    BOOL result =[[UMSocialManager defaultManager] handleOpenURL:url];
    if(!result){
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)initUmeng {
//    [UMConfigure initWithAppkey:@"Your appkey" channel:@"App Store"];
}

- (void)confitUShareSettings {
 
}

- (void)configUSharePlatforms {
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Whatsapp appKey:@"" appSecret:@"" redirectURL:@""];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Instagram appKey:@"" appSecret:@"" redirectURL:@""];
}


@end
