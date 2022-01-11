//
//  CartEmptyView.h
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "ProductSimilarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartEmptyView : UIView

- (void)configDataWithSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList;

@end

NS_ASSUME_NONNULL_END
