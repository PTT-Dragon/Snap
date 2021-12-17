//
//  ProductGroupListCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/17.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(void);

@interface ProductGroupListCell : UITableViewCell
@property (nonatomic, copy) Block joinBlock;
@property (nonatomic,strong) ProductGroupListModel *model;
@end

NS_ASSUME_NONNULL_END
