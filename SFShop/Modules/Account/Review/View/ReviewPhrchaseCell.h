//
//  ReviewPhrchaseCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/6.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewPhrchaseCell : UITableViewCell
@property (nonatomic,strong) PurchaseReviewModel *model;
@property (nonatomic,strong) PurchaseReviewModel *reviewModel;
@end

NS_ASSUME_NONNULL_END
