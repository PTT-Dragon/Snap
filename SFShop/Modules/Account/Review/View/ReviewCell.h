//
//  ReviewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReviewCellBlock)(OrderModel *model);

@interface ReviewCell : UITableViewCell
@property (nonatomic,copy) ReviewCellBlock block;
@property (nonatomic,copy) ReviewCellBlock additionBlock;
- (void)setContent:(OrderModel *)model type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
