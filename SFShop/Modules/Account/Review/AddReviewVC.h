//
//  AddReviewVC.h
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import "BaseViewController.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddReviewVCBlock)(void);

@interface AddReviewVC : BaseViewController
@property (nonatomic,copy) AddReviewVCBlock block;
- (void)setContent:(OrderModel *)model block:(AddReviewVCBlock)block;
@end

NS_ASSUME_NONNULL_END
