//
//  CategoryRankFilterInputItem.h
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankFilterInputItem : UICollectionViewCell

@property (nonatomic, readwrite, strong) CategoryRankPriceModel *model;
@property (nonatomic, readwrite, copy) void(^priceIntervalBlock)(NSInteger price, BOOL minOrMax);

@end

NS_ASSUME_NONNULL_END
