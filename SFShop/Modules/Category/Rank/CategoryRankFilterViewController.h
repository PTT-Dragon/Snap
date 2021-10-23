//
//  CategoryRankFilterViewController.h
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankFilterViewController : UIViewController

/// 透传数据
@property (nonatomic, readwrite, strong) CategoryRankModel *model;

@end

NS_ASSUME_NONNULL_END
