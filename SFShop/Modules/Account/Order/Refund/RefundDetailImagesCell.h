//
//  RefundDetailImagesCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import <UIKit/UIKit.h>
#import "refundModel.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefundDetailImagesCellBlock)(NSArray *imgArr);

@interface RefundDetailImagesCell : UITableViewCell
@property (nonatomic,assign) BOOL canSel;
@property (nonatomic,strong) NSArray <EvaluatesContentsModel *>*content;
@property (nonatomic,copy) RefundDetailImagesCellBlock block;
@end

NS_ASSUME_NONNULL_END
