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
@end

@interface SFNetworkUsersAddressModule : NSObject

@property (nonatomic, readwrite, strong) NSString *addressList;
@end

@interface SFNetworkUsersCouponModule : NSObject

@property (nonatomic, readwrite, strong) NSString *usercoupons;
@property (nonatomic, readwrite, strong) NSString *center;
@property (nonatomic, readwrite, strong) NSString *usercoupon;


@end

@interface SFNetworkUsersFavoriteModule : NSObject

@property (nonatomic, readwrite, strong) NSString *favorite;
@property (nonatomic, readwrite, strong) NSString *delete;


@end

NS_ASSUME_NONNULL_END
