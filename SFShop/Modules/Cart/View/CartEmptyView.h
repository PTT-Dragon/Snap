//
//  CartEmptyView.h
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "favoriteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartEmptyView : UIView

- (void)configDataWithSimilarList:(NSMutableArray<favoriteModel *> *)similarList;
@property (nonatomic,assign) BOOL isTab;//是否是tab页的购物车

@end

NS_ASSUME_NONNULL_END
