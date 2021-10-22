//
//  ReviewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewCell : UITableViewCell
- (void)setContent:(OrderModel *)model type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
