//
//  MGCShareItemModel.h
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/4/30.
//

#import <Foundation/Foundation.h>

/// 分享类型
typedef NS_ENUM(NSUInteger, MGCShareItemType) {
    MGCShareItemTypeWeChatFriend = 1,//微信好友
    MGCShareItemTypeWeChatTimeline,//微信朋友圈
    MGCShareItemTypeQQFriend,//QQ好友
    MGCShareItemTypeQZone,//QQ空间
    MGCShareItemTypeWeibo,//新浪微博
    MGCShareItemTypeWeChatFriendMini,//微信好友小程序
    MGCShareItemTypeQQFriendMini,//QQ好友小程序
    MGCShareItemTypeMore,//更多分享
    
    MGCShareItemTypeReport,//举报
    MGCShareItemTypeCopyUrl,//复制链接
    MGCShareItemTypeUnLike,//不喜欢
    MGCShareItemTypeCollect,//收藏
    MGCShareItemTypeHaveCollect,//已收藏
    MGCShareItemTypeRefresh,//刷新
    MGCShareItemTypeDelete,//删除
    MGCShareItemTypeAuthoritySetting,//权限设置
    MGCShareItemTypeMoveDelete,//移除
    MGCShareItemTypeCRBTManager,//彩铃管理
    MGCShareItemTypeUseCommonSense,//使用小常识
    MGCShareItemTypeSharePic,//生成海报
    MGCShareItemTypeTemplate,//魔性小视频使用模板
    MGCShareItemTypeColorPrint,//设为彩印
    MGCShareItemTypeTransferStorage,//保存和彩云
    MGCShareItemTypeConentDissatisfied,//内容太水
    MGCShareItemTypeDisConentDissatisfied,//内容太水置灰
    MGCShareItemTypeRing,//彩铃
    MGCShareItemTypeShoot,//拍同款
    MGCShareItemTypeDownLoad,//下载本地
    MGCShareItemTypeOpenSafari//打开浏览器

};

NS_ASSUME_NONNULL_BEGIN

/* 提示语 */
#define QQ_NOT_INSTALL_OR_NOT_SUPPORT @"您尚未安装QQ或QQ版本过低"
#define SINAWEIBO_NOT_INSTALL_OR_NOT_SUPPORT @"您尚未安装微博或微博版本过低"
#define WECHAT_NOT_INSTALL_OR_NOT_SUPPORT @"您尚未安装微信或微信版本过低"
#define ForceBindingPhoneTips @"根据有关规定 第三方帐号需要绑定用户手机号"
/* 图片 */
#define SHARE_IMG_COMPRESSION_QUALITY 0.5

@interface MGCShareItemModel : NSObject

//名称
@property (nonatomic, copy) NSString *itemName;
//图标imageName
@property (nonatomic, copy) NSString *itemImage;
//分享Item类型
@property (nonatomic, assign) MGCShareItemType itemType;
//按钮是否置灰
@property(nonatomic,assign) BOOL isEnable;

@end

NS_ASSUME_NONNULL_END
