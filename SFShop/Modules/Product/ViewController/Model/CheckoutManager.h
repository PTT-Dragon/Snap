//
//  CheckoutManager.h
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import <Foundation/Foundation.h>
#import "ProductCalcFeeModel.h"
#import "OrderLogisticsModel.h"
#import "CouponsAvailableModel.h"
#import "ProductCheckoutModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SFPayResult) {
    SFPayResultFailed, //支付失败 （如果是mock 环境，可以直接设置支付失败）
    SFPayResultSuccess,//支付成功 （如果是mock 环境，可以直接设置支付成功）
    SFPayResultJumpToWebPay,//跳转到web支付，⚠️正式环境一般走这里
};

@interface CheckoutManager : NSObject

/// 单例
+ (instancetype)shareInstance;


// 开始购买
- (void)startPayWithOrderIds:(NSArray *)orderIds shareBuyOrderNbr:(NSString *)shareBuyOrderNbr totalPrice:(NSString *)totalPrice complete:(void(^)(SFPayResult result, NSString * _Nullable urlOrHtml, NSDictionary * _Nullable response))complete;

#pragma mark - 加载结算数据
/// 加载进入checkout 页面所需数据
/// @param model ProductCheckoutModel
/// @param complete 完成回调
- (void)loadCheckoutData:(ProductCheckoutModel *)model complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete;

#pragma mark - 更新,在初始化之后才能使用
/// 求配送信息更新==> 重新结算
/// @param logisticsItem 配送数据
/// @param storeId 店铺id
/// @param complete complete
- (void)calfeeByLogistic:(OrderLogisticsItem *)logisticsItem storeId:(NSInteger)storeId complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete ;

/// 地址信息更新 ==> 重新请求配送信息计算 和 结算
/// @param addressModel 地址
/// @param complete complete
- (void)calfeeByAddress:(addressModel *)addressModel complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete;

///  计算费用(商店优惠券更新)
/// @param storeCouponItem 商店优惠券更新
/// @param storeId 店铺id
/// @param complete complete
- (void)calfeeByStoreCouponItem:(CouponItem *)storeCouponItem storeId:(NSInteger)storeId complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete;

///  计算费用(平台优惠券更新)
/// @param pltCouponItem 平台优惠券更新
/// @param complete complete
- (void)calfeeByPltCouponItem:(CouponItem *)pltCouponItem complete:(void(^)(BOOL isSuccess, ProductCheckoutModel *checkoutModel))complete ;
@end

NS_ASSUME_NONNULL_END
