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
- (NSString *)userInfo {
    return K_users_domain(@"");
}
- (NSString *)codeCheck {
    return K_users_domain(@"code/check");
}
- (NSString *)pwdModify {
    return K_users_domain(@"pwd/modify");
}
- (NSString *)bindEmail {
    return K_users_domain(@"email/binding");
}
- (NSString *)phoneModify {
    return K_users_domain(@"phone/modify");
}
- (NSString *)logout {
    return K_users_domain(@"logout");
}

@end

@implementation SFNetworkUsersCartModule
- (NSString *)cart {
    return K_cart_domain(@"");
}
- (NSString *)del {
    return K_cart_domain(@"delete");
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
- (NSString *)num {
    return K_coupon_domain(@"state/num");
}
- (NSString *)couponCatg {
    return K_coupon_domain(@"couponCatg");
}

@end

@implementation SFNetworkUsersFavoriteModule
- (NSString *)favorite {
    return K_favorite_domain(@"");
}
- (NSString *)del {
    return K_favorite_domain(@"delete");
}
- (NSString *)similar {
    return K_favorite_domain(@"similar");
}
- (NSString *)num {
    return K_favorite_domain(@"num");
}

@end

@implementation SFNetworkUsersEvaluateModule
- (NSString *)addEvaluate {
    return K_evaluate_domain(@"");
}


@end

@implementation SFNetworkUsersRefundModule

- (NSString *)refundList {
    return K_refund_domain(@"");
}
- (NSString *)getDetailOf: (NSString *)offerId {
    NSString *url = [NSString stringWithFormat:@"/%@", offerId];
    return K_refund_domain(url);
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
    return K_invite_domain(@"activity/rule");
}
- (NSString *)activityInvShare {
    return K_invite_domain(@"activity/share");
}
- (NSString *)activityInvRecord {
    return K_invite_domain(@"activity/invRecord");
}
- (NSString *)activityInvTrends {
    return K_invite_domain(@"activity/trends");
}
- (NSString *)img {
    return K_invite_domain(@"img");
}

@end

@implementation SFNetworkUsersOrderModule
- (NSString *)list {
    return K_order_domain(@"");
}

- (NSString *)confirmOrder {
    return K_order_domain(@"confirmreceipt");
}
- (NSString *)cancelOrder {
    return K_order_domain(@"cancel");
}
- (NSString *)cancelOrderReason {
    return K_order_domain(@"");
}
- (NSString *)getReasonlOf: (NSString *)eventId
{
    NSString *url = [NSString stringWithFormat:@"/%@", eventId];
    return K_orderReason_domain(url);
}


@end

@implementation SFNetworkUsersRecentModule

- (NSString *)num {
    return K_recent_domain(@"recent/num");
}
- (NSString *)list {
    return K_recent_domain(@"recent/list");
}


@end

@implementation SFNetworkH5Module

- (NSString *)agreement {
    return K_h5_domain(@"agreement");
}
- (NSString *)faqList {
    return K_h5_domain(@"faq/catalog/list");
}
- (NSString *)faqQuestion {
    return K_h5_domain(@"/faq/question/page");
}
- (NSString *)getReceiptOf: (NSString *)orderId
{
    NSString *url = [NSString stringWithFormat:@"/receipt/%@", orderId];
    return K_h5_domain(url);
}

@end
