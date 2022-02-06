//
//  ReplaceDeliveryViewController.h
//  SFShop
//
//  Created by 游挺 on 2022/1/24.
//

#import <UIKit/UIKit.h>
#import "refundModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReplaceDeliveryViewControllerBlock)(void);

@interface ReplaceDeliveryViewController : UIViewController
@property (nonatomic,copy) ReplaceDeliveryViewControllerBlock block;
@property (nonatomic,strong) refundModel *model;
@end

NS_ASSUME_NONNULL_END
