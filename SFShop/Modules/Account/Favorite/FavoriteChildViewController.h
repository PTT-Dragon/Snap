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



@interface FavoriteChildViewController : UIViewController
@property (nonatomic,assign) FavoriteType type;
@property (nonatomic,strong) CategoryRankModel *rankModel;

- (void)reloadDatas;
@end

NS_ASSUME_NONNULL_END
