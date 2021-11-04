//
//  ProductCheckoutSectionHeader.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "ProductCheckoutModel.h"
#import "SFCellCacheModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductCheckoutSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, readwrite, strong) SFCellCacheModel *cellModel;

@end

NS_ASSUME_NONNULL_END
