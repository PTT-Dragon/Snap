//
//  CheckoutManager.m
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import "CheckoutManager.h"
#import "addressModel.h"

@interface CheckoutManager ()
@property (nonatomic, readwrite, strong) CheckoutInputData *data;
@end

@implementation CheckoutManager

static CheckoutManager *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CheckoutManager alloc] init];
    });
    return _instance;
}

- (void)loadCheckoutData:(CheckoutInputData *)data complete:(void(^)(ProductCalcFeeModel *feeModel, OrderLogisticsModel *_Nullable logisticsModel, CouponsAvailableModel *couponsModel))complete {
    self.data  = data;
    [MBProgressHUD showHudMsg:@""];
    __block ProductCalcFeeModel *feeModel = nil;
    __block OrderLogisticsModel *logisticsModel = nil;
    __block CouponsAvailableModel *couponsModel = nil;
    dispatch_group_t group = dispatch_group_create();
    //请求结算数据
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.calcfee parameters: data.calcfeeParams success:^(id  _Nullable response) {
            feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
            dispatch_group_leave(group);
        }];
    });
    
    //请求配送数据
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.logistics parameters:data.logisticsParams success:^(id  _Nullable response) {
            NSDictionary *data = ((NSArray *)response).firstObject;
            logisticsModel = [[OrderLogisticsModel alloc] initWithDictionary:data error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"logistics Failed!"];
            dispatch_group_leave(group);
        }];
    });
    
    //请求商品优惠券数据
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.couponsAvailable parameters:data.couponsAvailableParams success:^(id  _Nullable response) {
            couponsModel = [[CouponsAvailableModel alloc] initWithDictionary:response error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"coupons Failed!"];
            dispatch_group_leave(group);
        }];
    });

    //获取数据,并进入结算页面
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        complete(feeModel,logisticsModel,couponsModel);
    });
}

- (void)updateAddress:(NSString *)deliveryAddressId complete:(void(^)(ProductCalcFeeModel *feeModel, OrderLogisticsModel *_Nullable logisticsModel))complete {
    NSAssert(self.data, @"没初始化CheckoutInputData,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(deliveryAddressId.length > 0, @"地址id不能为空");
    self.data.deliveryAddressId = deliveryAddressId;
    [SFNetworkManager post:SFNet.order.logistics parameters:self.data.logisticsParams success:^(id  _Nullable response) {
        NSDictionary *data = ((NSArray *)response).firstObject;
        OrderLogisticsModel *logisticsModel = [[OrderLogisticsModel alloc] initWithDictionary:data error:nil];
        NSString *logisticsModeId = logisticsModel.logistics.firstObject.logisticsModeId;
        NSAssert(logisticsModeId.length > 0, @"配送id不能为空");
        self.data.logisticsModeId = logisticsModeId;
        [SFNetworkManager post:SFNet.order.calcfee parameters: self.data.calcfeeParams success:^(id  _Nullable response) {
            ProductCalcFeeModel *feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
            !complete ?: complete(feeModel,logisticsModel);
        } failed:^(NSError * _Nonnull error) {
            !complete ?: complete(nil,logisticsModel);
            [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
        }];
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(nil,nil);
        [MBProgressHUD autoDismissShowHudMsg: @"logistics Failed!"];
    }];
}

- (void)updateLogistic:(NSString *)logisticsModeId complete:(void(^)(ProductCalcFeeModel *feeModel))complete {
    NSAssert(self.data, @"没初始化CheckoutInputData,请在 loadCheckoutData 函数返回数据之后调用");
    NSAssert(logisticsModeId.length > 0, @"配送id不能为空");
    self.data.logisticsModeId = logisticsModeId;
    [SFNetworkManager post:SFNet.order.calcfee parameters: self.data.calcfeeParams success:^(id  _Nullable response) {
        ProductCalcFeeModel *feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
        !complete ?: complete(feeModel);
    } failed:^(NSError * _Nonnull error) {
        !complete ?: complete(nil);
        [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
    }];
}

@end
