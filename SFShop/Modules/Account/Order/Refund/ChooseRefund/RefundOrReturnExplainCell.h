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

typedef void(^RefundOrReturnExplainCellBlock)(NSString *text);

@interface RefundOrReturnExplainCell : UITableViewCell

@property (nonatomic,assign) RefundOrReturnViewType type;
@property (nonatomic,copy) RefundOrReturnExplainCellBlock block;
@property (nonatomic,strong) RefundChargeModel *chargeModel;
@end

NS_ASSUME_NONNULL_END
