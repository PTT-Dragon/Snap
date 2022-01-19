//
//  MGCShareView.h
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/4/30.
//

#import <UIKit/UIKit.h>
#import "MGCShareItemModel.h"
#import "MGCShareInfoModel.h"
//#import "MGCShareViewModel.h"


//分享页面类型
typedef NS_ENUM(NSInteger, MGCShareViewType) {
    //正常两行
    MGCShareViewTypeNormal = 0,
    //只有分享
    MGCShareViewTypeOnlyShare,
    //只有工具
    MGCShareViewTypeOnlyTool
};


@interface MGCShareView : UIView

@property (nonatomic, strong) MGCShareInfoModel *shareInfoModel;

@property (nonatomic, copy) void (^successBlock)(NSDictionary *info, MGCShareItemType type);

@property (nonatomic, copy) void (^failBlock)(NSDictionary *info, MGCShareItemType type);

@property (nonatomic, copy) NSString *contentType;

+ (MGCShareView *)showShareViewWithSuperView:(UIView *)superView
                              shareInfoModel:(MGCShareInfoModel *)shareInfoModel
                                successBlock:(void (^)(NSDictionary *info, MGCShareItemType type))successBlock
                                   failBlock:(void (^)(NSDictionary *info, MGCShareItemType type))failBlock
                                   completed:(void (^)(BOOL isShow))completed;
/// 删除视图
- (void)cancelBtnAction;

@end

