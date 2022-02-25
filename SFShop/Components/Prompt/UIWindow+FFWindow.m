//
//  UIWindow+FFWindow.m
//  FFFilter
//
//  Created by feng.lu on 2021/12/21.
//

#import "UIWindow+FFWindow.h"

@implementation UIWindow (FFWindow)

+ (UIWindow *)ffGetKeyWindow {
    UIWindow *originalKeyWindow = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in windows) {
            if (window.isKeyWindow) {
                originalKeyWindow = window;
                break;
            }
        }
#endif
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
        originalKeyWindow = [UIApplication sharedApplication].keyWindow;
#endif
    }
    return originalKeyWindow;
}

@end
