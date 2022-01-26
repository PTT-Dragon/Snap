//
//  MGCShareView.h
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/4/30.
//

#import <UIKit/UIKit.h>
#import "MGCShareInfoModel.h"
#import <UShareUI/UShareUI.h>

@interface MGCShareView : UIView

@property (nonatomic, strong) MGCShareInfoModel *shareInfoModel;

@property (nonatomic, copy) void (^successBlock)(NSDictionary *info, UMSocialPlatformType type);

@property (nonatomic, copy) void (^failBlock)(NSDictionary *info, UMSocialPlatformType type);

+ (MGCShareView *)showShareViewWithShareInfoModel:(MGCShareInfoModel *)shareInfoModel
                                     successBlock:(void (^)(NSDictionary *info, UMSocialPlatformType type))successBlock
                                        failBlock:(void (^)(NSDictionary *info, UMSocialPlatformType type))failBlock
                                        completed:(void (^)(BOOL isShow))completed;
/// 删除视图
- (void)cancelBtnAction;

@end

