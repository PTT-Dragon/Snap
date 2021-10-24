//
//  CategoryRankFilterViewController.h
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CategoryRankFilterRefreshType) {
    CategoryRankFilterRefreshCancel,//取消
    CategoryRankFilterRefreshReset,//重置
    CategoryRankFilterRefreshUpdate,//更新
};

@interface CategoryRankFilterViewController : UIViewController

/// 透传数据
@property (nonatomic, readwrite, strong) CategoryRankModel *model;

/// 回调
@property (nonatomic, readwrite, copy) void (^filterRefreshBlock)(CategoryRankFilterRefreshType type,CategoryRankModel *model);

@end

NS_ASSUME_NONNULL_END
