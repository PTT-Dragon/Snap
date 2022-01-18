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
@property (nonatomic,weak) OrderModel *model;
@property (nonatomic,copy) NSString *orderItemId;
@end

NS_ASSUME_NONNULL_END
