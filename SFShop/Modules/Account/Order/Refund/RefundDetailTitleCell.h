//
//  RefundDetailTitleCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import <UIKit/UIKit.h>
#import "refundModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefundDetailTitleCell : UITableViewCell
- (void)setContent:(RefundDetailModel *)model type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
