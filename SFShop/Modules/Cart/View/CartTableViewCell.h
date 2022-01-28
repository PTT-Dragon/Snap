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

- (void)modifyCartInfoWithDic:(NSDictionary *)dic;
- (void)skuActionWithModel:(CartItemModel *)model;

@end

@interface CartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (nonatomic,assign) id<CartTableViewCellDelegate>delegate;
@property (nonatomic,weak) CartItemModel *model;
@property (nonatomic,assign) BOOL isInvalid;
@end

NS_ASSUME_NONNULL_END
