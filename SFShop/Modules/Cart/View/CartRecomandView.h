//
//  CartRecomandView.h
//  SFShop
//
//  Created by Lufer on 2022/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartRecomandView : UIView

- (void)configDataWithSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList;

@end

NS_ASSUME_NONNULL_END
