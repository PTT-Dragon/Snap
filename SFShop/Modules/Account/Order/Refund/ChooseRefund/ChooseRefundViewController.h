//
//  ChooseRefundViewController.h
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "BaseViewController.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseRefundViewController : BaseViewController
@property (nonatomic,copy) OrderDetailModel *model;
@property (nonatomic,assign) NSInteger row;
@end

NS_ASSUME_NONNULL_END
