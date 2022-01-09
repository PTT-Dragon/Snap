//
//  CheckoutManager.h
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import <Foundation/Foundation.h>
#import "CheckoutInputData.h"
#import "ProductCalcFeeModel.h"
#import "OrderLogisticsModel.h"
#import "CouponsAvailableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckoutManager : NSObject

/// 单例
+ (instancetype)shareInstance;

#pragma mark - 初始化
/// 加载进入checkout 页面所需数据
/// @param data 初始化数据
/// @param complete 完成回调
- (void)loadCheckoutData:(CheckoutInputData *)data complete:(void(^)(ProductCalcFeeModel *feeModel, OrderLogisticsModel *_Nullable logisticsModel, CouponsAvailableModel *couponsModel))complete;

#pragma mark - 更新,在初始化之后才能使用
/// 求配送信息更新==> 重新结算
/// @param logisticsModeId 配送id
/// @param complete complete
- (void)calfeeByLogistic:(NSString *)logisticsModeId complete:(void(^)(ProductCalcFeeModel *feeModel))complete;

/// 地址信息更新 ==> 重新请求配送信息计算 和 结算
/// @param deliveryAddressId 地址id
/// @param complete complete
- (void)calfeeByAddress:(NSString *)deliveryAddressId complete:(void(^)(ProductCalcFeeModel *feeModel, OrderLogisticsModel *_Nullable logisticsModel))complete;

///  计算费用(商店优惠券更新)
/// @param selUserCouponId 商店优惠券更新
/// @param complete complete
- (void)calfeeBySelUserCouponId:(NSString *)selUserCouponId complete:(void(^)(ProductCalcFeeModel *feeModel))complete;

///  计算费用(平台优惠券更新)
/// @param selUserPltCouponId 平台优惠券更新
/// @param complete complete
- (void)calfeeBySelUserPltCouponId:(NSString *)selUserPltCouponId complete:(void(^)(ProductCalcFeeModel *feeModel))complete;
@end

NS_ASSUME_NONNULL_END
