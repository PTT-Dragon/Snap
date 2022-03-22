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
typedef void(^DeleteImageBlock)(NSInteger index);
typedef void(^selTagBlock)(EvaluatesModel *evaModel,NSInteger row);

@interface AddReviewItemCell : UITableViewCell
@property (nonatomic,copy) reviewItemBlock block;
@property (nonatomic,copy) reviewItemTextBlock textBlock;
@property (nonatomic,copy) reviewItemRateBlock rateBlock;
@property (nonatomic,copy) selTagBlock tagBlock;
- (void)setContent:(orderItemsModel *)orderModel row:(NSInteger)row imgArr:(NSMutableArray *)imgArr text:(NSString *)text rate:(NSString *)rate evaModel:(EvaluatesModel *)evaModel;

/**
 删除图片回调
 */
@property (nonatomic, copy) DeleteImageBlock deleteImageBlock;

@end

NS_ASSUME_NONNULL_END
