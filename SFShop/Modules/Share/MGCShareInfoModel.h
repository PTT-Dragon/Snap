//
//  MGCShareInfoModel.h
//  MiguDMShare
//
//  Created by 陆锋 on 2021/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGCShareInfoModel : NSObject

//分享标题
@property (nonatomic, copy) NSString *shareTitle;
//分享标签
@property (nonatomic, copy) NSString *shareLabel;
//分享正文
@property (nonatomic, copy) NSString *shareText;
//分享图标地址
@property (nonatomic, copy) NSString *shareIconUrl;
//分享链接地址
@property (nonatomic, copy) NSString *shareLinkUrl;
//微博分享正文
@property (nonatomic, copy) NSString *weiboShareText;
//是否分享图片  这个属性 不是接口返回的 ，是自己定义的， 需要使用的话 记得赋值 ，默认为NO
@property (nonatomic, assign) BOOL isSharePic;
//这个图片是针对分享出去是单独的一个图片处理的， 需要isSharePic == YES的时候才生效
@property (nonatomic, strong) UIImage *shareImage;
//qrcode不需要显示大图
@property (nonatomic, assign) BOOL isSharePersonQRCode;

@end

NS_ASSUME_NONNULL_END
