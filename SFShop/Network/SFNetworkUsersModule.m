//
//  SFNetworkUsersModule.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkUsersModule.h"

@implementation SFNetworkUsersModule

- (NSString *)login {
    return K_users_domain(@"login");
}

@end

@implementation SFNetworkUsersAddressModule
- (NSString *)addressList {
    return K_address_domain(@"delivery");
}
@end

@implementation SFNetworkUsersCouponModule

- (NSString *)usercoupons {
    return K_coupon_domain(@"usercoupons");
}
@end
