//
//  CouponModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/19.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol userCouponsModel

@end


@interface CouponNumModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*availableNum;
@property (nonatomic,copy) NSString <Optional>*usedNum;
@property (nonatomic,copy) NSString <Optional>*expiredNum;
@end

@interface userCouponsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*transOrderId;
@property (nonatomic,copy) NSString <Optional>*getDate;
@property (nonatomic,copy) NSString <Optional>*state;


@end

@interface CouponModel : JSONModel

@property (nonatomic,copy) NSString <Optional>*couponName;
@property (nonatomic,copy) NSString <Optional>*couponId;
@property (nonatomic,copy) NSString <Optional>*discountMethod;
@property (nonatomic,copy) NSString <Optional>*effDate;
@property (nonatomic,copy) NSString <Optional>*expDate;
@property (nonatomic,copy) NSString *expDateStr;
@property (nonatomic,copy) NSString *effDateStr;
@property (nonatomic,copy) NSString <Optional>*getDate;
@property (nonatomic,copy) NSString <Optional>*getMethod;
@property (nonatomic,copy) NSString <Optional>*initiator;
@property (nonatomic,copy) NSString <Optional>*isOrderTh;
@property (nonatomic,copy) NSString <Optional>*isOverlay;
@property (nonatomic,copy) NSString <Optional>*getOffsetExp;
@property (nonatomic,assign) double quantity;
@property (nonatomic,assign) double discountAmount;
@property (nonatomic,assign) BOOL isGet;
@property (nonatomic,copy) NSString <Optional>*productId;
@property (nonatomic,copy) NSString <Optional>*isPrmotCode;
@property (nonatomic,copy) NSString <Optional>*stateDate;
@property (nonatomic,copy) NSString <Optional>*storeName;
@property (nonatomic,copy) NSString <Optional>*thAmount;
@property (nonatomic,copy) NSString <Optional>*useDesc;
@property (nonatomic,copy) NSString <Optional>*userCouponId;
@property (nonatomic,copy) NSString <Optional>*storeLogo;
@property (nonatomic,copy) NSString <Optional>*userCouponState;
@property (nonatomic,strong) NSArray <Optional>*targetProduct;
@property (nonatomic,strong) NSArray <userCouponsModel>*userCoupons;
@property (nonatomic,copy) NSString <Optional>*userCouponEffDate;
@property (nonatomic,copy) NSString <Optional>*userCouponExpDate;

/**
 {
comments = "<null>";
couponId = 68;
couponName = "Baby coupons";
discountAmount = 45;
discountMethod = AMT;
effDate = "2021-09-09 00:00:00";
expDate = "2021-09-30 23:59:59";
getDate = "2021-09-16 17:25:06";
getMethod = A;
initiator = STO;
isOrderTh = Y;
isOverlay = Y;
isPrmotCode = N;
maxDiscAmount = "<null>";
notEffectShow = 0;
prmotCodeType = "<null>";
promotCode = "<null>";
promotCodeInstId = "<null>";
stateDate = "2021-09-16 17:25:06";
storeId = 11;
storeLogo = "<null>";
storeName = "Apple Store";
targetObjIdList =             (
);
targetObjNameList = "<null>";
targetObjNames = "<null>";
targetOfferType = ALL;
thAmount = 344;
uniPromotCode = "<null>";
useDesc = 333333;
userCouponId = 20502;
userCouponState = C;
userId = 1197;
willExpireShow = 0;
}
 **/
@end

@interface CouponCategoryModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*couponCatgId;
@property (nonatomic,copy) NSString <Optional>*couponCatgName;
@property (nonatomic,copy) NSString <Optional>*isPltOnly;
@end

@interface CouponOrifeeModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*totalPrice;
@property (nonatomic,strong) CouponModel *couponInfo;


@end

NS_ASSUME_NONNULL_END
