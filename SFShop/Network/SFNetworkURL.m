//
//  SFNetworkURL.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkURL.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"

@implementation SFNetworkURL

static SFNetworkURL *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SFNetworkURL alloc] init];
        [_instance lz_initProperties];
    });
    return _instance;
}

@end
