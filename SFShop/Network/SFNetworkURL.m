//
//  SFNetworkURL.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkURL.h"

@interface SFNetworkURL ()
@property (nonatomic, readwrite, strong) SFNetworkLoginModule *account;
@property (nonatomic, readwrite, strong) SFNetworkH5Module *h5;
@end

@implementation SFNetworkURL

static SFNetworkURL *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SFNetworkURL alloc] init];
    });
    return _instance;
}

- (SFNetworkH5Module *)h5 {
    if (_h5 == nil) {
        _h5 = [[SFNetworkH5Module alloc] init];
    }
    return _h5;
}

- (SFNetworkLoginModule *)account {
    if (_account == nil) {
        _account = [[SFNetworkLoginModule alloc] init];
    }
    return _account;
}

@end
