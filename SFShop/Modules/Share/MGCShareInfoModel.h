//
//  MGCShareInfoModel.h
//  MiguDMShare
//
//  Created by 陆锋 on 2021/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MGCCardInfo;
@class MGCShareCyOpenInfoModel;


@interface MGCShareInfoModel : NSObject

//卡片活动信息 shareType=50 才有返回
@property (nonatomic, strong) MGCCardInfo *cardInfo;
//分享标题
@property (nonatomic, copy) NSString * shareTitle;
//分享标签
@property (nonatomic, copy) NSString * shareLabel;
//分享正文
@property (nonatomic, copy) NSString * shareText;
//分享图标地址
@property (nonatomic, copy) NSString * shareIconUrl;
//分享链接地址
@property (nonatomic, copy) NSString * shareLinkUrl;
//微博分享正文
@property (nonatomic, copy) NSString * weiboShareText;
//是否分享图片  这个属性 不是接口返回的 ，是自己定义的， 需要使用的话 记得赋值 ，默认为NO
@property (nonatomic, assign) BOOL isSharePic;
//这个图片是针对分享出去是单独的一个图片处理的， 需要isSharePic == YES的时候才生效
@property (nonatomic, strong) UIImage *shareImage;
//qrcode不需要显示大图
@property (nonatomic, assign) BOOL isSharePersonQRCode;
//分享图片展示的用户名称。
@property (nonatomic, copy) NSString * shareNickName;
//分享图片展示的描述文案。
@property (nonatomic, copy) NSString * shareImageDesc;
//分享图片展示的用户头像。
@property (nonatomic, copy) NSString * shareAvatarImage;
//分享图片展示的用户ID。
@property (nonatomic, copy) NSString * shareUserId;

@end


@interface MGCCardInfo : NSObject

@property (nonatomic, copy) NSString *backgroundImageUrls; // 卡片背景图片
@property (nonatomic, copy) NSString *desc; // 卡片描述
@property (nonatomic, copy) NSString *cardLink; // 卡片链接
@property (nonatomic, copy) NSString *other; // 其他（用于扩展）

@end

@interface MGCShareCyOpenInfoModel : NSObject

@property (nonatomic, copy) NSString * productId; // 产品id
@property (nonatomic, copy) NSString * simpleDesc; // 简要说明文字
@property (nonatomic, copy) NSString * costs; // 费用 （单位：分）
@property (nonatomic, copy) NSString * detailUrl; // 了解更多(详情)地址

@end


NS_ASSUME_NONNULL_END
