//
//  UITableView+ShowFootTableView.m
//  SFShop
//
//  Created by 别天神 on 2022/2/7.
//

#import "UITableView+ShowFootTableView.h"

@implementation UITableView (ShowFootTableView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(reload);
        SEL swizzledSelector = @selector(resetTableViewInsert);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzleMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod),method_getTypeEncoding(originalMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    });
}

- (void)resetTableViewInsert {
    [self setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
}

@end
