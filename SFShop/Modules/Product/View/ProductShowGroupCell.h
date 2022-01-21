//
//  ProductShowGroupCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/22.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ProductShowGroupCellBlock)(void);

@interface ProductShowGroupCell : UITableViewCell
@property (nonatomic,copy) ProductShowGroupCellBlock block;
@property (nonatomic,strong) ProductGroupListModel *model;
@end

NS_ASSUME_NONNULL_END
