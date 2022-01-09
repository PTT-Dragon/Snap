//
//  ProductCheckoutModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <Foundation/Foundation.h>
#import "CouponsAvailableModel.h"
#import "OrderLogisticsModel.h"
#import "addressModel.h"
#import "ProductCalcFeeModel.h"
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN
//商品选项
@interface ProductCheckoutSubItemModel : NSObject
@property (nonatomic, readwrite, strong) NSString *storeName;//storeName 字段
@property (nonatomic, readwrite, strong) NSString *productIcon;//产品icon
@property (nonatomic, readwrite, strong) NSString *productTitle;//产品标题
@property (nonatomic, readwrite, strong) NSString *productCategpry;//产品分类
@property (nonatomic, readwrite, assign) NSString *priceRp;//价格单位
@property (nonatomic, readwrite, assign) float productPrice;//产品价格
@property (nonatomic, readwrite, assign) NSInteger productNum;//产品数量
@end

@interface ProductCheckoutModel : NSObject
//商品model
@property (nonatomic, readwrite, strong) NSArray<ProductDetailModel *> *productModels;
//商品个数
@property (nonatomic, readwrite, strong) NSArray<NSNumber *> *productBuyCounts;
//商品id
@property (nonatomic, readwrite, strong) NSArray<NSNumber *> *productIds;
//商品折扣id
@property (nonatomic, readwrite, strong) NSArray<NSNumber *> *inCmpIdList;
//价格单位
@property (nonatomic, readwrite, assign) NSString *currency;
//配送模型
@property (nonatomic, readwrite, assign) NSString *deliveryMode;

//购买类型
@property (nonatomic, readwrite, strong) NSString *sourceType;

//商品选项列表
@property (nonatomic, readwrite, strong) NSArray<ProductCheckoutSubItemModel *> *productList;

//最后提示信息相关
@property (nonatomic, readwrite, strong) NSString *notes;//备注

/*
 结算数据
 1、⚠️不能为nil
 */
@property (nonatomic, readwrite, strong) ProductCalcFeeModel *feeModel;


/*
 地址数据
 1、可以为空
 2、每次更换地址之后,需要根据地址id,重新请求投递数据
 */
@property (nonatomic, readwrite, strong, nullable) addressModel *addressModel;


/*
 投递数据
 1、可以为空
 2、每次更新投递数据之后需要重新计算总价
 */
@property (nonatomic, readwrite, strong, nullable) OrderLogisticsModel *logisticsModel;
@property (nonatomic, readwrite, strong, nullable) OrderLogisticsItem *currentLogisticsItem;


/*
 优惠券
 1、可以为空
 2、每次更新之后需要重新计算总价
 */
@property (nonatomic, readwrite, strong, nullable) CouponsAvailableModel *couponsModel;//数据源
@property (nonatomic, readwrite, strong, nullable) CouponItem *currentStoreCoupon;//当前商店优惠券
@property (nonatomic, readwrite, strong, nullable) CouponItem *currentPltCoupon;//平台优惠券

@end

NS_ASSUME_NONNULL_END
