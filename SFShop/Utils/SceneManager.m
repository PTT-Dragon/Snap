//
//  SceneManager.m
//  SFShop
//
//  Created by YouHui on 2022/1/11.
//

#import "SceneManager.h"

@implementation SceneManager

+ (void)transToHome {
    [self transToTab:0];
}

+ (void)transToTab:(NSInteger)index {
    id tabViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    if (!tabViewController) {
        tabViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    }
    
    if (![tabViewController isKindOfClass:UITabBarController.class]) {
        NSAssert(NO, @"未登录状态不能跳转到TabBar");
    } else if (index >= ((UITabBarController *)tabViewController).viewControllers.count) {
        NSAssert(NO, @"跳转 TabBar Index 溢出");
    } else {
        UITabBarController *tab = tabViewController;
        [tab setSelectedIndex:index];
        UINavigationController *nav = tab.viewControllers[index];
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:YES];
        }
    }
}


@end
