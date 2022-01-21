//
//  ProductShowGroupView.h
//  SFShop
//
//  Created by 游挺 on 2022/1/22.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductShowGroupView : UIView
@property (nonatomic,strong) NSArray <ProductGroupListModel *>*dataSource;

@property (nonatomic, copy) void(^joinBlock)(ProductGroupListModel *model);

@end

NS_ASSUME_NONNULL_END
