//
//  SFNetworkLoginModule.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkLoginModule.h"
#import "SFNetworkMacro.h"

@implementation SFNetworkLoginModule

- (NSString *)login {
    return K_account_domain(@"login");
}
- (NSString *)check {
    return K_account_domain(@"check");
}
- (NSString *)getCode {
    return K_account_domain(@"code");
}
- (NSString *)codeCheck {
    return K_account_domain(@"code/check");
}

@end
