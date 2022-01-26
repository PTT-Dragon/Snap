//
//  AppDelegate.m
//  SFShop
//
//  Created by MasterFly on 2021/9/22.
//

#import "AppDelegate.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "SysParamsModel.h"

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
    [self loadSysConfig];
    [self initUmeng];
//    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabVC = [[MainTabViewController alloc] init];
    self.window.rootViewController = self.tabVC;
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
    self.tabVC = [[MainTabViewController alloc] init];
    self.window.rootViewController = self.tabVC;
}

-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if(!result){
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)initUmeng {
    [UMConfigure initWithAppkey:@"61e3e1dbe0f9bb492bd15ad7" channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
}

- (void)confitUShareSettings {
 
}

- (void)configUSharePlatforms {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"GrhZesIx4mD6rmhBufaabj8ac"  appSecret:@"6HUB0ch9yrsIJQG5iqqeMNHmnlall7fydviuveyYjKtZ3g5Aw5" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"640405423870824"  appSecret:@"c6410391d3be2bc1c2718b32af2b2d25" redirectURL:@"http://www.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Whatsapp appKey:@"64b0257eadbe5ec9c8ccca64a871ae5d-133ed03e-1e33-412b-a6b4-c061e7a8a5b3" appSecret:@"" redirectURL:@"ejyr31.api.infobip.com"];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Instagram appKey:@"" appSecret:@"" redirectURL:@""];
}
- (void)loadSysConfig
{
    [SFNetworkManager get:SFNet.h5.sysparam parameters:@{@"paramCodes":@"DEF_CURRENCY_DISPLAY,DEF_CURRENCY_PRECISION,DISPLAY_CURRENCY_PRECISION,PHONE_REGULAR_RULE,EMAIL_REGULAR_RULE,MINIMUM_DAILY_WITHDRAWAL,MAXIMUM_DAILY_WITHDRAWAL,CODE_TTL"} success:^(id  _Nullable response) {
        SysParamsItemModel *model = [SysParamsItemModel sharedSysParamsItemModel];
        for (NSDictionary *dic in response) {
            if ([dic[@"paramCode"] isEqualToString:@"DEF_CURRENCY_DISPLAY"]) {
                model.CURRENCY_DISPLAY = dic[@"paramValue"];
            }else if ([dic[@"paramCode"] isEqualToString:@"DEF_CURRENCY_PRECISION"]){
                model.CURRENCY_PRECISION = dic[@"paramValue"];
            }else if ([dic[@"paramCode"] isEqualToString:@"CODE_TTL"]){
                model.CURRENCY_DISPLAY = dic[@"paramValue"];
            }
        }
        
    } failed:^(NSError * _Nonnull error) {
        [self performSelector:@selector(loadSysConfig) withObject:nil afterDelay:10];
    }];
}



@end
