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

/// 基础分享只有五个三方分享带自定义工具栏
/// @param type 分享类型 拥有五个默认分享场景
/// @param shareTitle 分享标题
/// @param shareText 分享正文
/// @param shareLabel 分享标签
/// @param weiboShareText 微博正文
/// @param shareLinkUrl 分享地址
/// @param shareIconUrl 分享图片地址
/// @param successBlock 成功回调 功能按键需要自己在外部实现功能
/// @param failBlock 失败回调
/// @param completed 展示成功的回调

+ (MGCShareView *)showWithShareInfoModel:(MGCShareInfoModel *)infoModel
                       functionItemsArr:(NSMutableArray <MGCShareItemModel *> *)functionItemsArr
                                superView:(UIView *)superView
                             successBlock:(void (^)(NSDictionary *info, MGCShareItemType type))successBlock
                                failBlock:(void (^)(NSDictionary *info, MGCShareItemType type))failBlock
                                completed:(void (^)(BOOL isShow))completed;

/// 分享只有工具栏
/// @param functionItemsArr 功能列表，包含刷新、复制、收藏等 根据外部需求自行自定义
/// @param successBlock 成功回调
/// @param failBlock 失败回调
/// @param completed 展示成功的回调

+ (MGCShareView *)showWithFunctionItemsArr:(NSMutableArray <MGCShareItemModel *> *)functionItemsArr
                                 superView:(UIView *)superView
                              successBlock:(void (^)(NSDictionary *info, MGCShareItemType type))successBlock
                                 failBlock:(void (^)(NSDictionary *info, MGCShareItemType type))failBlock
                                 completed:(void (^)(BOOL isShow))completed;

/// 举报
+ (MGCShareItemModel *)reportFunctionItem;
/// 复制链接
+ (MGCShareItemModel *)copyLinkFunctionItem;
/// 收藏
+ (MGCShareItemModel *)collectFunctionItem;
// 已收藏
+ (MGCShareItemModel *)haveCollectFunctionItem;
/// 刷新
+ (MGCShareItemModel *)refreshFunctionItem;
/// 删除
+ (MGCShareItemModel *)deleteFunctionItem;
//权限设置
+ (MGCShareItemModel *)authoritySettingFunctionItem;
//移除
+ (MGCShareItemModel *)moveDeleteFunctionItem;
//彩铃管理
+ (MGCShareItemModel *)CRBTManagerFunctionItem;
//使用小常识
+ (MGCShareItemModel *)useCommonSensFunctionItem;
//生成海报
+ (MGCShareItemModel *)SharePicFunctionItem;
// 不喜欢
+ (MGCShareItemModel *)unlikeFunctionItem;
//魔性小视频使用模板
+ (MGCShareItemModel *)TemplateFunctionItem;
//设为彩印
+ (MGCShareItemModel *)colorPrintFunctionItem;
//保存和彩云
+ (MGCShareItemModel *)transferStorageFunctionItem;
//内容太水
+ (MGCShareItemModel *)conentDissatisfiedFunctionItem;
//内容太水置灰
+ (MGCShareItemModel *)disConentDissatisfiedFunctionItem;
//彩铃管理
+ (MGCShareItemModel *)ringManagerFunctionItem;
//下载本地
+ (MGCShareItemModel *)dowmloadFunctionItem;
//打开浏览器
+ (MGCShareItemModel *)openSafariFunctionItem;

/// 加载默认分享按钮
- (void)prepareDefaultShareItem;
/// 加载自定义工具栏按钮
- (void)prepareFunctionItemsWithItemsArr:(NSMutableArray *)itemsArr;
/// 根据不同的场景显示页面视图
- (void)prepareCollectionWithViewType:(MGCShareViewType)type;
/// 展示分享图
- (void)prepareShowBigShareImage;
/// 删除视图
- (void)cancelBtnAction;

@end

