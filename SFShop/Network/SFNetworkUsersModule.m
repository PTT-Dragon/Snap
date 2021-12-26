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
- (NSString *)resetPwd
{
    return K_users_domain(@"pwd/reset");
}
- (NSString *)messageList
{
    return K_users_domain(@"inbox/stat");
}
- (NSString *)readMessage
{
    return K_users_domain(@"inbox/read");
}
- (NSString *)message
{
    return K_users_domain(@"inbox/message");
}


@end

@implementation SFNetworkUsersCartModule
- (NSString *)cart {
    return K_cart_domain(@"");
}
- (NSString *)modify {
    return K_cart_domain(@"modify");
}
- (NSString *)del {
    return K_cart_domain(@"delete");
}
- (NSString *)coupons {
    return K_cart_domain(@"coupons");
}
- (NSString *)collection {
    return K_cart_domain(@"usercollection");
}


@end

@implementation SFNetworkUsersAddressModule
- (NSString *)addressList {
    return K_address_domain(@"delivery");
}
- (NSString *)areaData {
    return K_address_domain(@"");
}
- (NSString *)modify {
    return K_address_domain(@"modify");
}
- (NSString *)setAddressModifyOfdeliveryAddressId: (NSString *)deliveryAddressId {
    NSString *url = [NSString stringWithFormat:@"/delivery/%@/modify", deliveryAddressId];
    return K_address_domain(url);
}
- (NSString *)setAddressDeleteOfdeliveryAddressId: (NSString *)deliveryAddressId {
    NSString *url = [NSString stringWithFormat:@"/delivery/%@/delete", deliveryAddressId];
    return K_address_domain(url);
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
- (NSString *)top {
    return K_favorite_domain(@"top");
}

@end

@implementation SFNetworkUsersEvaluateModule
- (NSString *)addEvaluate {
    return K_evaluate_domain(@"");
}
- (NSString *)detail {
    return K_evaluate_domain(@"detail");
}
- (NSString *)getEvaluateOf: (NSString *)evaluateId
{
    NSString *url = [NSString stringWithFormat:@"evaluations/%@", evaluateId];
    return K_offers_domain(url);
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

- (NSString *)calcfee {
    return K_order_domain(@"calcfee");
}

- (NSString *)save {
    return K_order_domain(@"save");
}

- (NSString *)mock {
    return K_pay_domain(@"mock");
}
- (NSString *)num {
    return K_order_domain(@"status/num");
}

- (NSString *)logistics {
    return K_order_domain(@"logistics");
}


@end

@implementation SFNetworkUsersRecentModule

- (NSString *)num {
    return K_recent_domain(@"recent/num");
}
- (NSString *)list {
    return K_recent_domain(@"recent/list");
}
- (NSString *)delete {
    return K_recent_domain(@"recent/delete");
}


@end

@implementation SFNetworkH5Module

- (NSString *)agreement {
    return K_h5_domain(@"agreement");
}
- (NSString *)pay {
    return K_h5_domain(@"pay");
}
- (NSString *)faqList {
    return K_h5_domain(@"faq/catalog/list");
}
- (NSString *)faqQuestion {
    return K_h5_domain(@"/faq/question/page");
}
- (NSString *)publishImg {
    return K_h5_domain(@"image");
}
- (NSString *)getReceiptOf: (NSString *)orderId
{
    NSString *url = [NSString stringWithFormat:@"receipt/%@?downloadFlag=N", orderId];
    return K_h5_domain(url);
}

@end
