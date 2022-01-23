//
//  AddReviewItemCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^reviewItemBlock)(NSInteger row);

@interface AddReviewItemCell : UITableViewCell
@property (nonatomic,copy) reviewItemBlock block;
- (void)setContent:(orderItemsModel *)orderModel row:(NSInteger)row imgArr:(NSMutableArray *)imgArr;
@end

NS_ASSUME_NONNULL_END
