//
//  MGCShareView.h
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/4/30.
//

#import <UIKit/UIKit.h>
#import "MGCShareInfoModel.h"

@interface MGCShareView : UIView

@property (nonatomic, strong) MGCShareInfoModel *shareInfoModel;

@property (nonatomic, copy) void (^successBlock)(NSDictionary *info, MGCShareType type);

@property (nonatomic, copy) void (^failBlock)(NSDictionary *info, MGCShareType type);

+ (MGCShareView *)showShareViewWithShareInfoModel:(MGCShareInfoModel *)shareInfoModel
                                     successBlock:(void (^)(NSDictionary *info, MGCShareType type))successBlock
                                        failBlock:(void (^)(NSDictionary *info, MGCShareType type))failBlock
                                        completed:(void (^)(BOOL isShow))completed;
/// 删除视图
- (void)cancelBtnAction;

@end

