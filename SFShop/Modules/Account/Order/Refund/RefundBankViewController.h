//
//  RefundBankViewController.h
//  SFShop
//
//  Created by 游挺 on 2022/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefundBankViewControllerBlock)(void);

@interface RefundBankViewController : UIViewController
@property (nonatomic,copy) RefundBankViewControllerBlock block;
@property (nonatomic,copy) NSString *orderApplyId;
@property (nonatomic,copy) NSString *refundOrderId;
@end

NS_ASSUME_NONNULL_END
