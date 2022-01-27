//
//  baseTool.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "baseTool.h"
#import "CartModel.h"
#import "UITabBar+CustomBadge.h"

@implementation baseTool
+ (void)removeVCFromNavigation:(UIViewController *)vc
{
    NSMutableArray<UIViewController *> *tmpArr = [NSMutableArray array];
    for (UIViewController *subVC in vc.navigationController.viewControllers) {
        [tmpArr addObject:subVC];
    }
    for (UIViewController *subVC in vc.navigationController.viewControllers) {
        if (vc == subVC) {
            [tmpArr removeObject:vc];
        }
    }
    vc.navigationController.viewControllers = tmpArr;
}
+ (void)removeVCFromNavigationWithVCName:(NSString *)vcName currentVC:(UIViewController *)currentVC
{
    NSMutableArray<UIViewController *> *tmpArr = [NSMutableArray array];
    for (UIViewController *subVC in currentVC.navigationController.viewControllers) {
        [tmpArr addObject:subVC];
    }
    for (UIViewController *subVC in currentVC.navigationController.viewControllers) {
        if ([NSStringFromClass([subVC class]) isEqualToString:vcName]) {
            [tmpArr removeObject:subVC];
        }
    }
    currentVC.navigationController.viewControllers = tmpArr;
}
+ (void)removeVCFromNavigationWithVCNameArr:(NSArray <NSString *> *)vcName currentVC:(UIViewController *)currentVC
{
    NSMutableArray<UIViewController *> *tmpArr = [NSMutableArray array];
    for (UIViewController *subVC in currentVC.navigationController.viewControllers) {
        [tmpArr addObject:subVC];
    }
    for (NSString *vc in vcName) {
        for (UIViewController *subVC in currentVC.navigationController.viewControllers) {
            if ([NSStringFromClass([subVC class]) isEqualToString:vc]) {
                [tmpArr removeObject:subVC];
            }
        }
    }
    currentVC.navigationController.viewControllers = tmpArr;
}
+ (UIViewController *)getCurrentVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
        
    }
    return result;
}
+ (void)updateCartNum
{
    [SFNetworkManager get:SFNet.cart.num success:^(id  _Nullable response) {
        CartNumModel *model = [[CartNumModel alloc] initWithDictionary:response error:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;  
        UITabBar *tabbar = [(UITabBarController*)appDelegate.tabVC tabBar];
        
        if ([model.num isEqualToString:@"0"] && [model.reduceNum isEqualToString:@"0"]) {
            [tabbar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:3];
        }else{
            [tabbar setBadgeStyle:kCustomBadgeStyleRedDot value:[model.num intValue] atIndex:3];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
    
}
@end
