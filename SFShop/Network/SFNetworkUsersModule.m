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
- (NSString *)modify {
    return K_users_domain(@"modify");
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
- (NSString *)center {
    return K_coupon_domain(@"center");
}
- (NSString *)usercoupon {
    return K_coupon_domain(@"usercoupon");
}

@end

@implementation SFNetworkUsersFavoriteModule
- (NSString *)favorite {
    return K_favorite_domain(@"");
}
- (NSString *)delete {
    return K_favorite_domain(@"delete");
}

@end
