//
//  RefundOrReturnExplainCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/18.
//

#import <UIKit/UIKit.h>
#import "RefundOrReturnViewController.h"
#import "OrderModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface RefundOrReturnExplainCell : UITableViewCell

@property (nonatomic,assign) RefundOrReturnViewType type;
@property (nonatomic,strong) RefundChargeModel *chargeModel;
@end

NS_ASSUME_NONNULL_END
