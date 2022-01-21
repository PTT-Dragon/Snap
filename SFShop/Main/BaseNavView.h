//
//  BaseNavView.h
//  SFShop
//
//  Created by Lufer on 2022/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseNavView;

@protocol BaseNavViewDelegate <NSObject>

- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickSearchBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickShareBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView;

@end

@interface BaseNavView : UIView

@property (nonatomic, weak) id<BaseNavViewDelegate> delegate;

- (void)configDataWithTitle:(NSString *)title;

- (void)updateIsOnlyShowMoreBtn:(BOOL)isOnly;

@end

NS_ASSUME_NONNULL_END
