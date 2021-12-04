//
//  SFSearchingView.h
//  SFShop
//
//  Created by MasterFly on 2021/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchingView : UIView

/// 请求联想
/// @param q 请求关键词
- (void)requestAssociate:(NSString *)q;

/// 选中block
@property (nonatomic, readwrite, copy) void(^selectedBlock)(NSString *q);

@end

NS_ASSUME_NONNULL_END
