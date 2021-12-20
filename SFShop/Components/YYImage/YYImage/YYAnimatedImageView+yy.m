//
//  YYAnimatedImageView+yy.m
//  榕创生活
//
//  Created by yunchou on 2021/8/2.
//  Copyright © 2021 游. All rights reserved.
//

#import "YYAnimatedImageView+yy.h"

@implementation YYAnimatedImageView (yy)
+ (void)load {
    // 获取系统的对象方法
    Method displayLayerMethod = class_getInstanceMethod(self, @selector(displayLayer:));
    
    // 获取自己定义的对象方法
    Method displayLayerNewMethod = class_getInstanceMethod(self, @selector(displayLayerNew:));
    
    // 方法交换
    method_exchangeImplementations(displayLayerMethod, displayLayerNewMethod);
}

- (void)displayLayerNew:(CALayer *)layer {
    
    Ivar imgIvar = class_getInstanceVariable([self class], "_curFrame");
    UIImage *img = object_getIvar(self, imgIvar);
    if (img) {
        layer.contents = (__bridge id)img.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}
@end
