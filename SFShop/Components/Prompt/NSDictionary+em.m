//
//  NSDictionary+em.m
//  xinyongdu
//
//  Created by 游 on 2018/7/23.
//  Copyright © 2018年 游. All rights reserved.
//

#import "NSDictionary+em.h"
#import <objc/runtime.h>

@implementation NSDictionary (em)
+ (void)load
{
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(setObject:forKey:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSDictionaryI"), @selector(em_setObject:forKey:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (void)em_setObject:(id)emObject forKey:(NSString *)key {
    if (emObject == nil) {
        @try {
            [self em_setObject:emObject forKey:key];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            emObject = [NSString stringWithFormat:@""];
            [self em_setObject:emObject forKey:key];
        }
        @finally {}
    }else {
        [self em_setObject:emObject forKey:key];
    }
}
@end
