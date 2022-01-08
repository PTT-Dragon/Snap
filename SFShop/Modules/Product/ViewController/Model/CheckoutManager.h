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

/// 加载进入checkout 页面所需数据
/// @param data 初始化数据
/// @param complete 完成回调
- (void)loadCheckoutData:(CheckoutInputData *)data complete:(void(^)(ProductCalcFeeModel *feeModel, OrderLogisticsModel *_Nullable logisticsModel, CouponsAvailableModel *couponsModel))complete;

@end

NS_ASSUME_NONNULL_END
