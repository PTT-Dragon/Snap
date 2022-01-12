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

/// 初始化
/// @param sourceType source 类型
/// @param addressModel 地址model
/// @param productModels 选中商店的选中产品
+ (instancetype)initWithsourceType:(NSString *)sourceType
                      addressModel:(addressModel *)addressModel
                     productModels:(NSArray<ProductDetailModel *> *)productModels;

//配送模型 默认A
@property (nonatomic, readwrite, assign) NSString *deliveryMode;

//购买类型
@property (nonatomic, readwrite, strong) NSString *sourceType;

/*
 商品model,
 1、一个ProductDetailModel 里面包含一个商店购买的商品
 */
@property (nonatomic, readwrite, strong) NSArray<ProductDetailModel *> *productModels;

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
 配送数据,所有商店的配送数据
 */
@property (nonatomic, readwrite, strong, nullable) NSArray<OrderLogisticsModel *> *logisticsModels;

/*
 优惠券
 */
@property (nonatomic, readwrite, strong, nullable) CouponsAvailableModel *couponsModel;//所有商店优惠券数据源
@property (nonatomic, readwrite, strong, nullable) CouponItem *currentPltCoupon;//平台优惠券

@end

NS_ASSUME_NONNULL_END
