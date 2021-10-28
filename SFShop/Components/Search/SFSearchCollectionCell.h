//
//  SFSearchCollectionCell.h
//  SFShop
//
//  Created by MasterFly on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "SFSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchCollectionCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) SFSearchModel *model;

@end

NS_ASSUME_NONNULL_END
