//
//  FavoriteChildViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "favoriteModel.h"
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FavoriteChildViewControllerBlock)(void);

@interface FavoriteChildViewController : UIViewController
@property (nonatomic,copy) FavoriteChildViewControllerBlock block;
@property (nonatomic,assign) FavoriteType type;
@property (nonatomic,strong) CategoryRankModel *rankModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;

- (void)reloadDatas;
@end

NS_ASSUME_NONNULL_END
