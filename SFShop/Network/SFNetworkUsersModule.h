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
@property (nonatomic, readwrite, strong) NSString *emailModify;
@property (nonatomic, readwrite, strong) NSString *phoneModify;
@property (nonatomic, readwrite, strong) NSString *logout;
@property (nonatomic, readwrite, strong) NSString *userInfo;
@property (nonatomic, readwrite, strong) NSString *resetPwd;
@property (nonatomic, readwrite, strong) NSString *messageList;
@property (nonatomic, readwrite, strong) NSString *message;
@property (nonatomic, readwrite, strong) NSString *readMessage;
@property (nonatomic, readwrite, strong) NSString *messageNum;

- (NSString *)setLanguageWithId:(NSString *)languageId;
- (NSString *)readChatMessage:(NSString *)chatId;


@end

@interface SFNetworkUsersCartModule : NSObject
@property (nonatomic, readwrite, strong) NSString *cart;
@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *del;
@property (nonatomic, readwrite, strong) NSString *modify;
@property (nonatomic, readwrite, strong) NSString *collection;
@property (nonatomic, readwrite, strong) NSString *coupons;
@property (nonatomic, readwrite, strong) NSString *orifee;


@end

@interface SFNetworkUsersAddressModule : NSObject

@property (nonatomic, readwrite, strong) NSString *addressList;
@property (nonatomic, readwrite, strong) NSString *areaData;
@property (nonatomic, readwrite, strong) NSString *modify;
- (NSString *)setAddressModifyOfdeliveryAddressId: (NSString *)deliveryAddressId;
- (NSString *)setAddressDeleteOfdeliveryAddressId: (NSString *)deliveryAddressId;
@end

@interface SFNetworkUsersCouponModule : NSObject

@property (nonatomic, readwrite, strong) NSString *usercoupons;
@property (nonatomic, readwrite, strong) NSString *center;
@property (nonatomic, readwrite, strong) NSString *usercoupon;
@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *couponCatg;
@property (nonatomic, readwrite, strong) NSString *couponBrief;
- (NSString *)getCouponInfoOf: (NSString *)couponId;



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
@property (nonatomic, readwrite, strong) NSString *method;
@property (nonatomic, readwrite, strong) NSString *confirm;
@property (nonatomic, readwrite, strong) NSString *save;
@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *logistics;
@property (nonatomic, readwrite, strong) NSString *couponsAvailable;
- (NSString *)getReasonlOf: (NSString *)eventId;
- (NSString *)getOrderEvaItemOf: (NSString *)itemId;
- (NSString *)logisticsDetailWithId:(NSString *)logiticsId shippingNbr:(NSString *)nbr deliveryId:(NSString *)deliveryId;

@end

@interface SFNetworkUsersRecentModule : NSObject

@property (nonatomic, readwrite, strong) NSString *num;
@property (nonatomic, readwrite, strong) NSString *list;
@property (nonatomic, readwrite, strong) NSString *delete;



@end

@interface SFNetworkUsersEvaluateModule : NSObject
//添加评论
@property (nonatomic, readwrite, strong) NSString *addEvaluate;
@property (nonatomic, readwrite, strong) NSString *detail;
@property (nonatomic, readwrite, strong) NSString *modify;
/**
 追评
**/
@property (nonatomic, readwrite, strong) NSString *review;

- (NSString *)getEvaluateOf: (NSString *)evaluateId;

@end

@interface SFNetworkUsersRefundModule : NSObject
//退货列表
@property (nonatomic, readwrite, strong) NSString *refundList;
@property (nonatomic, readwrite, strong) NSString *charge;
@property (nonatomic, readwrite, strong) NSString *refund;
@property (nonatomic, readwrite, strong) NSString *delivery;
@property (nonatomic, readwrite, strong) NSString *cancel;
@property (nonatomic, readwrite, strong) NSString *applyDelivery;
@property (nonatomic, readwrite, strong) NSString *acct;




- (NSString *)getDetailOf: (NSString *)offerId;
@end

@interface SFNetworkH5Module : NSObject

@property (nonatomic, readwrite, strong) NSString *agreement;
@property (nonatomic, readwrite, strong) NSString *faqList;
@property (nonatomic, readwrite, strong) NSString *faqQuestion;
@property (nonatomic, readwrite, strong) NSString *publishImg;
@property (nonatomic, readwrite, strong) NSString *pay;
@property (nonatomic, readwrite, strong) NSString *sysparam;


- (NSString *)getReceiptOf: (NSString *)orderId;

@end



NS_ASSUME_NONNULL_END
