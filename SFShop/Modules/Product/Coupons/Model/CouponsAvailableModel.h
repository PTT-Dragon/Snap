//
//  CouponsAvailableModel.h
//  SFShop
//
//  Created by MasterFly on 2022/1/2.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CouponsStoreModel;
@protocol CouponItem;
@class CouponsStoreModel;
@class CouponItem;

@interface CouponsAvailableModel : JSONModel
@property (nonatomic, readwrite, strong) NSString *selUserPltCouponId;
@property (nonatomic, readwrite, strong) NSArray<CouponsStoreModel *> <CouponsStoreModel> *storeAvailableCoupons;//店铺优惠券
@property (nonatomic, readwrite, strong) NSArray<CouponItem *> <CouponItem> *pltAvailableCoupons;//平台优惠券
@end

    @interface CouponsStoreModel : JSONModel
    @property (nonatomic, readwrite, assign) NSInteger storeId;
    @property (nonatomic, readwrite, assign) NSInteger selUserCouponId;
    @property (nonatomic, readwrite, strong) NSArray<CouponItem *> <CouponItem> *availableCoupons;//优惠数组
    @end

        @interface CouponItem : JSONModel
            @property (nonatomic, readwrite, assign) long userCouponId;
            @property (nonatomic, readwrite, assign) long couponId;
            @property (nonatomic, readwrite, strong) NSString *couponName;
            @property (nonatomic, readwrite, strong) NSString *effDate;
            @property (nonatomic, readwrite, strong) NSString *expDate;
            @property (nonatomic, readwrite, strong) NSString *useDesc;
            @property (nonatomic, readwrite, strong) NSString *isOrderTh;
            @property (nonatomic, readwrite, assign) long thAmount;
            @property (nonatomic, readwrite, strong) NSString *discountMethod;
            @property (nonatomic, readwrite, assign) long discountAmount;
            @property (nonatomic, readwrite, assign) long maxDiscAmount;
            
            //自定义,是否被选中
            @property (nonatomic, readwrite, assign) BOOL isSelected;
        @end

NS_ASSUME_NONNULL_END
