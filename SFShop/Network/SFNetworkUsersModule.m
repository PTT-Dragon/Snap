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
- (NSString *)pwdpolicy {
    return K_users_domain(@"pwdpolicy");
}
- (NSString *)check {
    return K_users_domain(@"check");
}
- (NSString *)getCode {
    return K_users_domain(@"code");
}
- (NSString *)codeCheck {
    return K_users_domain(@"code/check");
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
- (NSString *)del {
    return K_favorite_domain(@"delete");
}

@end

@implementation SFNetworkUsersInviteModule
- (NSString *)activity {
    return K_invite_domain(@"activity");
}
- (NSString *)activityInfo {
    return K_invite_domain(@"activity/info");
}
- (NSString *)activityInvRule {
    return K_invite_domain(@"activity/info");
}
- (NSString *)activityInvShare {
    return K_invite_domain(@"activity/info");
}
- (NSString *)activityInvRecord {
    return K_invite_domain(@"activity/info");
}
- (NSString *)activityInvTrends {
    return K_invite_domain(@"activity/info");
}
- (NSString *)img {
    return K_invite_domain(@"img");
}


@end

@implementation SFNetworkUsersOrderModule
- (NSString *)list {
    return K_order_domain(@"");
}


@end

@implementation SFNetworkH5FavoriteModule

- (NSString *)agreement {
    return K_h5_domain(@"agreement");
}

@end
