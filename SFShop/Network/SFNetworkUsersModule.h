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

@end

@interface SFNetworkUsersAddressModule : NSObject

@property (nonatomic, readwrite, strong) NSString *addressList;
@end

@interface SFNetworkUsersCouponModule : NSObject

@property (nonatomic, readwrite, strong) NSString *usercoupons;
@property (nonatomic, readwrite, strong) NSString *center;
@property (nonatomic, readwrite, strong) NSString *usercoupon;
@property (nonatomic, readwrite, strong) NSString *num;


@end

@interface SFNetworkUsersFavoriteModule : NSObject

@property (nonatomic, readwrite, strong) NSString *favorite;
@property (nonatomic, readwrite, strong) NSString *del;
@property (nonatomic, readwrite, strong) NSString *similar;

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


@end

@interface SFNetworkH5FavoriteModule : NSObject

@property (nonatomic, readwrite, strong) NSString *agreement;


@end



NS_ASSUME_NONNULL_END
