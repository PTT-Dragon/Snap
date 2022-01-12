//
//  ProductCheckoutBaseCell.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "ProductCheckoutModel.h"
#import "SFCellCacheModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,  ProductCheckoutCellEvent) {
    ProductCheckoutCellEvent_GotoStoreVoucher,
    ProductCheckoutCellEvent_GotoAddress,
};

@interface ProductCheckoutBaseCell : UITableViewCell

@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;//总数据
@property (nonatomic, readwrite, strong) SFCellCacheModel *cellModel;//cell 复用，布局数据（不含业务）
@property (nonatomic, readwrite, strong, nullable) ProductDetailModel *detailModel;//商店数据，可空。在商店cell 时才传入该数据

/// cell 事件回调,通过cellid 和枚举来区分事件
@property (nonatomic, readwrite, copy) void(^eventBlock)(ProductCheckoutModel *dataModel,SFCellCacheModel *cellModel, ProductCheckoutCellEvent event);

@end

NS_ASSUME_NONNULL_END
