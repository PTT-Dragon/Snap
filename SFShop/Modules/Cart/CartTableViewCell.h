//
//  CartTableViewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CartTableViewCellDelegate <NSObject>

- (void)refreshData;

@end

@interface CartTableViewCell : UITableViewCell
@property (nonatomic,assign) id<CartTableViewCellDelegate>delegate;
@property (nonatomic,weak) CartItemModel *model;
@end

NS_ASSUME_NONNULL_END
