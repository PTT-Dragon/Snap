//
//  StarView.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^StarViewSelBlock)(NSInteger score);

@interface StarView : UIView
@property (nonatomic,copy) StarViewSelBlock block;
@property (nonatomic,assign) NSInteger score;//分数
@property (nonatomic,assign) BOOL canSel;//是否可点击
@end

NS_ASSUME_NONNULL_END
