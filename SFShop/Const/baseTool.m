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
    UserModel *userModel = [FMDBManager sharedInstance].currentUser;
    if (!userModel) {
        NSDictionary *aaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrayKey"];
        CartModel *modelsd = [[CartModel alloc] initWithDictionary:aaaaa error:nil];
        __block NSInteger count = 0;
        [modelsd.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                count++;
            }];
        }];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBar *tabbar = [(UITabBarController*)appDelegate.tabVC tabBar];
        if (count == 0) {
            [tabbar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:3];
        }else{
            [tabbar setBadgeStyle:kCustomBadgeStyleRedDot value:count atIndex:3];
        }
        return;
    }
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
