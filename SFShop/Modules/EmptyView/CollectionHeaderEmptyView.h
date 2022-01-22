//
//  CollectionHeaderEmptyView.h
//  SFShop
//
//  Created by MasterFly on 2022/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionHeaderEmptyView : UICollectionReusableView

- (void)configDataWithEmptyType:(EmptyViewType)type;

- (void)updateTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
