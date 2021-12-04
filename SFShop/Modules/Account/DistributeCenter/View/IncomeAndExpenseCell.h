//
//  IncomeAndExpenseCell.h
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeAndExpenseCell : UITableViewCell
@property (nonatomic,weak) IncomeOrWithdrawListModel *model;
@end

NS_ASSUME_NONNULL_END
