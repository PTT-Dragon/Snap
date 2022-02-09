//
//  RefundProcessCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "refundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefundProcessCell : UITableViewCell

- (void)setContent:(RefundDetailMemosModel *)model hideView:(BOOL)hideView isLast:(BOOL)isLast;
@end

NS_ASSUME_NONNULL_END
