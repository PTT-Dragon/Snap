//
//  SFNetworkUsersModule.h
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkUsersModule : NSObject

@property (nonatomic, readwrite, strong) NSString *login;
@property (nonatomic, readwrite, strong) NSString *check;
@property (nonatomic, readwrite, strong) NSString *getCode;
@property (nonatomic, readwrite, strong) NSString *codeCheck;
@property (nonatomic, readwrite, strong) NSString *modify;
@property (nonatomic, readwrite, strong) NSString *pwdpolicy;
@property (nonatomic, readwrite, strong) NSString *pwdModify;
@property (nonatomic, readwrite, strong) NSString *bindEmail;
@property (nonatomic, readwrite, strong) NSString *phoneModify;
@property (nonatomic, readwrite, strong) NSString *logout;
@property (nonatomic, readwrite, strong) NSString *userInfo;
@property (nonatomic, readwrite, strong) NSString *resetPwd;



@end

@interface SFNetworkUsersCartModule : NSObject
@property (nonatomic, readwrite, strong) NSString *cart;
@property (nonatomic, readwrite, strong) NSString *del;
@property (nonatomic, readwrite, strong) NSString *modify;
@property (nonatomic, readwrite, strong) NSString *collection;
@end

@interface SFNetworkUsersAddressModule : NSObject

@property (nonatomic, readwrite, strong) NSString *addressList;
@property (nonatomic, readwrite, strong) NSString *areaData;
@property (nonatomic, readwrite, strong) NSString *modify;
- (NSString *)setAddressModifyOfdeliveryAddressId: (NSString *)deliveryAddressId;
@end

@interface SFNetworkUsersCouponModule : NSObject

@property (nonatomic, readwrite, strong) NSString *usercoupons;
@property (nonatomic, readwrite, strong) NSString *center;
@property (nonatomic, readwrite, strong) NSString *usercoupon;
@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *couponCatg;


@end

@interface SFNetworkUsersFavoriteModule : NSObject

@property (nonatomic, readwrite, strong) NSString *favorite;
@property (nonatomic, readwrite, strong) NSString *del;
@property (nonatomic, readwrite, strong) NSString *similar;
@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *top;

@end

@interface SFNetworkUsersInviteModule : NSObject

@property (nonatomic, readwrite, strong) NSString *activity;
@property (nonatomic, readwrite, strong) NSString *activityInfo;
@property (nonatomic, readwrite, strong) NSString *activityInvRecord;
@property (nonatomic, readwrite, strong) NSString *activityInvRule;
@property (nonatomic, readwrite, strong) NSString *activityInvShare;
@property (nonatomic, readwrite, strong) NSString *activityInvTrends;
@property (nonatomic, readwrite, strong) NSString *img;

@end

@interface SFNetworkUsersOrderModule : NSObject

@property (nonatomic, readwrite, strong) NSString *list;
@property (nonatomic, readwrite, strong) NSString *confirmOrder;
@property (nonatomic, readwrite, strong) NSString *cancelOrder;
@property (nonatomic, readwrite, strong) NSString *cancelOrderReason;
@property (nonatomic, readwrite, strong) NSString *calcfee;
@property (nonatomic, readwrite, strong) NSString *save;
@property (nonatomic, readwrite, strong) NSString *mock;
- (NSString *)getReasonlOf: (NSString *)eventId;

@end

@interface SFNetworkUsersRecentModule : NSObject

@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *list;


@end

@interface SFNetworkUsersEvaluateModule : NSObject
//添加评论
@property (nonatomic, readwrite, strong) NSString *addEvaluate;
@property (nonatomic, readwrite, strong) NSString *detail;

@end

@interface SFNetworkUsersRefundModule : NSObject
//退货列表
@property (nonatomic, readwrite, strong) NSString *refundList;
- (NSString *)getDetailOf: (NSString *)offerId;
@end

@interface SFNetworkH5Module : NSObject

@property (nonatomic, readwrite, strong) NSString *agreement;
@property (nonatomic, readwrite, strong) NSString *faqList;
@property (nonatomic, readwrite, strong) NSString *faqQuestion;
@property (nonatomic, readwrite, strong) NSString *publishImg;
@property (nonatomic, readwrite, strong) NSString *pay;
- (NSString *)getReceiptOf: (NSString *)orderId;

@end



NS_ASSUME_NONNULL_END
