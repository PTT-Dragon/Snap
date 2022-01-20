//
//  AddReviewViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddReviewViewControllerBlock)(void);

@interface AddReviewViewController : UIViewController
@property (nonatomic,copy) AddReviewViewControllerBlock block;
- (void)setContent:(OrderModel *)model row:(NSInteger)row orderItemId:(NSString *)orderItemId block:(AddReviewViewControllerBlock)block;
@end

NS_ASSUME_NONNULL_END
