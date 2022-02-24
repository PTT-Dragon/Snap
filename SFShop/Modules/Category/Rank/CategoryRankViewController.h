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

/// 是否聚焦搜索
@property (nonatomic, readwrite, assign, getter=isActiveSearch) BOOL activeSearch;

/// 点击返回是否需要返回到主页
@property (nonatomic, readwrite, assign, getter=isShouldBackToHome) BOOL shouldBackToHome;

//  可能会从外部直接传进来参数
@property (nonatomic,copy) NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
