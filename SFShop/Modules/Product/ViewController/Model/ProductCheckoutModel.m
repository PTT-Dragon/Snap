//
//  ProductCheckoutModel.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutModel.h"

@implementation ProductCheckoutSubItemModel

@end


@interface ProductCheckoutModel ()
@property (nonatomic, readwrite, assign) float totalPrice;//总价
@end
@implementation ProductCheckoutModel

- (void)setLogisticsModel:(OrderLogisticsModel *)logisticsModel {
    _logisticsModel = logisticsModel;
    
    //重新填充地址数据,默认选中第一个配送数据
    OrderLogisticsItem * logisticsItem = logisticsModel.logistics.firstObject;
    logisticsItem.isSelected = YES;
    self.currentLogisticsItem = logisticsItem;
}

@end
