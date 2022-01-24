//
//  ReplaceDeliveryCell.h
//  SFShop
//
//  Created by 游挺 on 2022/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReplaceDeliveryCellBlock)(NSDictionary *infoDic,NSInteger row);
typedef void(^ReplaceDeliveryCellDeleteBlock)(NSInteger row);

@interface ReplaceDeliveryCell : UITableViewCell
@property (nonatomic,copy) ReplaceDeliveryCellBlock block;
@property (nonatomic,copy) ReplaceDeliveryCellDeleteBlock deleteBlock;

- (void)setContent:(NSMutableDictionary *)dic row:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
