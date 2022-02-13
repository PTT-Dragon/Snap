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
typedef void(^reviewItemTextBlock)(NSString *text,NSInteger row);
typedef void(^reviewItemRateBlock)(NSString *score,NSInteger row);

@interface AddReviewItemCell : UITableViewCell
@property (nonatomic,copy) reviewItemBlock block;
@property (nonatomic,copy) reviewItemTextBlock textBlock;
@property (nonatomic,copy) reviewItemRateBlock rateBlock;
- (void)setContent:(orderItemsModel *)orderModel row:(NSInteger)row imgArr:(NSMutableArray *)imgArr text:(NSString *)text rate:(NSString *)rate;
@end

NS_ASSUME_NONNULL_END
