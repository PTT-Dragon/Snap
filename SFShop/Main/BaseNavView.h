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

@optional

- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickSearchBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickShareBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView;

- (void)baseNavViewDidClickClearBtn:(BaseNavView *)navView;

@end

@interface BaseNavView : UIView

@property (nonatomic, weak) id<BaseNavViewDelegate> delegate;

- (void)configDataWithTitle:(NSString *)title;

- (void)updateIsOnlyShowMoreBtn:(BOOL)isOnly;
- (void)updateIsShowClearBtn:(BOOL)isOnly;
- (void)updateIsShowArticleTop:(BOOL)isOnly;
- (void)configDataWithAnchorName:(NSString *)title anchorImgUrl:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_END
