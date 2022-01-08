//
//  DeleveryViewController.h
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "OrderLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeleveryViewController : UIViewController

@property (nonatomic, readwrite, strong) NSMutableArray<OrderLogisticsItem *> *dataArray;

@property (nonatomic, readwrite, copy) void(^selectedDeleveryBlock)(OrderLogisticsItem *_Nullable item);

@end

NS_ASSUME_NONNULL_END
