//
//  SFSearchNav.h
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "SFSearchItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchNav : UIView

/// 初始化
/// @param frame frame
/// @param bitem 返回item
/// @param rItem 右上角item
- (instancetype)initWithFrame:(CGRect)frame backItme:(SFSearchItem *)bitem rightItem:(SFSearchItem *)rItem;

@end

NS_ASSUME_NONNULL_END
