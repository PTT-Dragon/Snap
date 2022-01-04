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
};

@interface ProductCheckoutBaseCell : UITableViewCell

@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, readwrite, strong) SFCellCacheModel *cellModel;
@property (nonatomic, readwrite, copy) void(^updateDataBlock)(ProductCheckoutModel *dataModel,SFCellCacheModel *cellModel);
@property (nonatomic, readwrite, copy) void(^addressBlock)(ProductCheckoutModel *dataModel,SFCellCacheModel *cellModel);


/// cell 事件回调,通过cellid 和枚举来区分事件
@property (nonatomic, readwrite, copy) void(^eventBlock)(ProductCheckoutModel *dataModel,SFCellCacheModel *cellModel, ProductCheckoutCellEvent event);

@end

NS_ASSUME_NONNULL_END
