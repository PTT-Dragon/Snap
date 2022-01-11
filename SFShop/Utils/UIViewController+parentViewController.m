//
//  UIViewController+parentViewController.m
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import "UIViewController+parentViewController.h"

@implementation UIViewController (parentViewController)

+ (UINavigationController *)currentNavigationController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ((![rootViewController isKindOfClass:[UITabBarController class]] && ![rootViewController isKindOfClass:[UINavigationController class]])
           && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]])
    {
        rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UINavigationController *navigationController = ((UITabBarController *)rootViewController).selectedViewController;
        while (navigationController.presentedViewController && [navigationController.presentedViewController isKindOfClass:UINavigationController.class]) {
            navigationController = (UINavigationController *)navigationController.presentedViewController;
        }
        return navigationController;
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        while (navigationController.presentedViewController && [navigationController.presentedViewController isKindOfClass:UINavigationController.class]) {
            navigationController = (UINavigationController *)navigationController.presentedViewController;
        }
        return navigationController;
    }
    
    return nil;
}

+ (UIViewController *)currentTopViewController {
    UIViewController *topViewController;
    UINavigationController *navigationController = [self currentNavigationController];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        topViewController = navigationController.topViewController;
    }
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        UINavigationController *navigationController = ((UITabBarController *)topViewController).selectedViewController;
        while (navigationController.presentedViewController && [navigationController.presentedViewController isKindOfClass:UINavigationController.class]) {
            navigationController = (UINavigationController *)navigationController.presentedViewController;
        }
        topViewController = navigationController;
    }
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

@end
