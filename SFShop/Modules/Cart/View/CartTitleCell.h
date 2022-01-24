//
//  CartTitleCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CartTitleCellDelegate <NSObject>

- (void)selAll:(BOOL)selAll storeId:(NSString *)storeId;
- (void)selCouponWithStoreId:(NSString *)storeId productArr:(NSArray *)arr;
- (void)selCouponWithStoreId:(NSString *)storeId productArr:(NSArray *)arr row:(NSInteger)row;
@end

@interface CartTitleCell : UITableViewCell
@property (nonatomic,assign) id<CartTitleCellDelegate>delegate;
@property (nonatomic,assign) BOOL isInvalid;
@property (nonatomic,assign) BOOL hasCoupon;
@property (nonatomic,weak) CartListModel *model;
@property (nonatomic,assign) NSInteger section;

@end

NS_ASSUME_NONNULL_END
