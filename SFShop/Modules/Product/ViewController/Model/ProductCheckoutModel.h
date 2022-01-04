//
//  ProductCheckoutModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <Foundation/Foundation.h>
#import "CouponsAvailableModel.h"

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

//购买类型
@property (nonatomic, readwrite, strong) NSString *sourceType;

//地址
@property (nonatomic, readwrite, strong) NSString *address;//地址
@property (nonatomic, readwrite, strong) NSString *email;//邮箱

//商品选项列表
@property (nonatomic, readwrite, strong) NSArray<ProductCheckoutSubItemModel *> *productList;

//投递
@property (nonatomic, readwrite, assign) NSString *priceRp;//价格单位
@property (nonatomic, readwrite, strong) NSString *deliveryTitle;//快递费用
@property (nonatomic, readwrite, assign) float deliveryPrice;//快递费用
@property (nonatomic, readwrite, strong) NSString *deliveryDes;//快递描述

//最后提示信息相关
@property (nonatomic, readwrite, strong) NSString *notes;//备注
@property (nonatomic, readwrite, assign) float promoReduce;//促销降价
@property (nonatomic, readwrite, assign) float totalPrice;//总价

//优惠券
@property (nonatomic, readwrite, strong) CouponsAvailableModel *couponsModel;//数据源
@property (nonatomic, readwrite, strong) CouponItem *currentStoreCoupon;//当前商店优惠券
@property (nonatomic, readwrite, strong) CouponItem *currentPltCoupon;//平台优惠券

@end

NS_ASSUME_NONNULL_END
