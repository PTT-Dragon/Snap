//
//  SFSearchSectionHeadView.h
//  SFShop
//
//  Created by MasterFly on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "SFSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchSectionHeadView : UICollectionReusableView

@property (nonatomic, readwrite, strong) SFSearchModel *model;
@property (nonatomic, readwrite, copy) void(^rightBlock)(SFSearchModel *model);

@end

NS_ASSUME_NONNULL_END
