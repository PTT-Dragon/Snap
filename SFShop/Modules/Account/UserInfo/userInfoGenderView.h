//
//  userInfoGenderView.h
//  SFShop
//
//  Created by 游挺 on 2021/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol userInfoGenderViewDelegate <NSObject>

- (void)chooseGender:(NSString *)gender;


@end

@interface userInfoGenderView : UIView

@property (nonatomic,assign) id<userInfoGenderViewDelegate>delegate;
/**
 选中的性别
 */
@property (nonatomic, copy) NSString *generStr;

@end

NS_ASSUME_NONNULL_END
