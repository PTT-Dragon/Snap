//
//  ChooseReasonViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseReasonViewControllerDelegate <NSObject>

- (void)chooseReason:(CancelOrderReasonModel *)model;

@end

@interface ChooseReasonViewController : UIViewController
@property (nonatomic,assign) id<ChooseReasonViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
