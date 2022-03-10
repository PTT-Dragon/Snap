//
//  CashOutDetailVC.h
//  SFShop
//
//  Created by 游挺 on 2022/3/10.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CashOutDetailVCBlock)(void);

@interface CashOutDetailVC : UIViewController
@property (nonatomic,copy) CashOutDetailVCBlock block;
@property (nonatomic,strong) CashOutHistoryListModel *model;
@end

NS_ASSUME_NONNULL_END
