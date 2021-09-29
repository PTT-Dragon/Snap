//
//  CategoryRankViewController.h
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankViewController : UIViewController

/// 上一级传入数据
@property (nonatomic, readwrite, strong) CategoryModel *model;

@end

NS_ASSUME_NONNULL_END
