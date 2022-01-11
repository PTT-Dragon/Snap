//
//  UIView+Response.h
//
//
//  Created by  on 21-1-11.
//  Copyright (c) 2021年 all rights reserved.
//

#import "UIView+Response.h"

@implementation UIView (Response)

- (UIViewController *)parentViewController{
    
    UIResponder *next = self.nextResponder;
    do {
        
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
        
    } while (next != nil);
    
    return nil;
}

- (UIViewController *)getCurrentVC{
    
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

@end
