//
//  ProductCheckoutModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductCheckoutModel : NSObject

//地址
@property (nonatomic, readwrite, strong) NSString *address;
@property (nonatomic, readwrite, strong) NSString *email;

//商品选项
@property (nonatomic, readwrite, strong) NSString *productIcon;
@property (nonatomic, readwrite, strong) NSString *productTitle;
@property (nonatomic, readwrite, strong) NSString *productCategpry;
@property (nonatomic, readwrite, assign) float productPrice;
@property (nonatomic, readwrite, assign) NSInteger productNum;

//投递
@property (nonatomic, readwrite, strong) NSString *deliveryPrice;
@property (nonatomic, readwrite, strong) NSString *deliveryDes;

//最后提示信息相关
@property (nonatomic, readwrite, strong) NSString *notes;
@property (nonatomic, readwrite, assign) NSInteger availableVouchersCount;
@property (nonatomic, readwrite, assign) float storePromo;
@property (nonatomic, readwrite, assign) float totalPrice;
@property (nonatomic, readwrite, assign) NSInteger shopAvailableVouchersCount;

@end

NS_ASSUME_NONNULL_END
