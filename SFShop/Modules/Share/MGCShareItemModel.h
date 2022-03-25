//
//  MGCShareItemModel.h
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 提示语 */
#define QQ_NOT_INSTALL_OR_NOT_SUPPORT @"您尚未安装QQ或QQ版本过低"
#define SINAWEIBO_NOT_INSTALL_OR_NOT_SUPPORT @"您尚未安装微博或微博版本过低"
#define WECHAT_NOT_INSTALL_OR_NOT_SUPPORT @"您尚未安装微信或微信版本过低"
#define ForceBindingPhoneTips @"根据有关规定 第三方帐号需要绑定用户手机号"
/* 图片 */
#define SHARE_IMG_COMPRESSION_QUALITY 0.5

/// 空页面type
typedef NS_ENUM(NSInteger, MGCShareType) {
    MGCShareTwitterType = 0, // 推特
    MGCShareFacebookType = 1, // facebook
    MGCShareWhatsAppType = 3, // WhatsApp
    MGCShareCopyLinkType = 4, // 拷贝
    MGCSharePosterType = 5, // 海报
    MGCShareSavePosterType = 7, // 保存海报图片
    MGCShareSavePosterToFacebookType = 8, // 分享海报到facebook
};

@interface MGCShareItemModel : NSObject

//名称
@property (nonatomic, copy) NSString *itemName;
//图标imageName
@property (nonatomic, copy) NSString *itemImage;
//分享Item类型
@property (nonatomic, assign) MGCShareType itemType;
//按钮是否置灰
@property(nonatomic,assign) BOOL isEnable;

@end

NS_ASSUME_NONNULL_END
