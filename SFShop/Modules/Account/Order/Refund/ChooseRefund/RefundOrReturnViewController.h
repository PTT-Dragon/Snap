//
//  RefundOrReturnViewController.h
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "BaseViewController.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum :NSUInteger{
    REFUNDTYPE,
    RETURNTYPE,
    REPLACETYPE,
}RefundOrReturnViewType;

@interface RefundOrReturnViewController : BaseViewController
@property (nonatomic,copy) OrderDetailModel *model;
@property (nonatomic,strong) RefundChargeModel *chargeModel;
@property (nonatomic,assign) RefundOrReturnViewType type;
@end

NS_ASSUME_NONNULL_END
