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

@end

@interface CartTitleCell : UITableViewCell
@property (nonatomic,assign) id<CartTitleCellDelegate>delegate;
@property (nonatomic,assign) BOOL isInvalid;
@property (nonatomic,weak) CartListModel *model;
@end

NS_ASSUME_NONNULL_END
