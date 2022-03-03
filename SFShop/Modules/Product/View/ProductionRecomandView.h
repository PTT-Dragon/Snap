//
//  ProductionRecomandView.h
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "ProductSimilarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductionRecomandView : UIView

- (void)configDataWithSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList;
@property (strong, nonatomic) UICollectionView *recommendCollectionView;

@end

NS_ASSUME_NONNULL_END
