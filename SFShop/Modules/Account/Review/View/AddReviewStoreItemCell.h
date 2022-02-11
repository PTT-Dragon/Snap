//
//  AddReviewStoreItemCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddReviewStoreItemRateBlock)(NSString *score1,NSString *score2,NSString *score3);
typedef void(^AddReviewStoreItemAnonymousBlock)(NSString *Anonymous);

@interface AddReviewStoreItemCell : UITableViewCell
@property (nonatomic,strong) OrderModel *model;
@property (nonatomic,strong) OrderDetailModel *detailModel;
@property (nonatomic,copy) AddReviewStoreItemRateBlock block;
@property (nonatomic,copy) AddReviewStoreItemAnonymousBlock anonymousblock;

@end

NS_ASSUME_NONNULL_END
