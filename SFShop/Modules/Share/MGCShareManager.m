//
//  MGCShareManager.m
//  SFShop
//
//  Created by Lufer on 2022/1/18.
//

#import "MGCShareManager.h"
#import <UShareUI/UShareUI.h>
#import "UIViewController+parentViewController.h"
#import "MGCShareView.h"

@implementation MGCShareManager

+ (instancetype)sharedInstance {
    static MGCShareManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MGCShareManager alloc] init];
    });
    return manager;
}

- (void)showShareViewWithShareMessage:(NSString *)message {
    MGCShareInfoModel *infoModel = [[MGCShareInfoModel alloc] init];
    [MGCShareView showShareViewWithShareInfoModel:infoModel
                                     successBlock:^(NSDictionary *info, UMSocialPlatformType type) {
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        if (type == UMSocialPlatformType_Facebook) {
            UMShareWebpageObject *webObje = [UMShareWebpageObject shareObjectWithTitle:@"" descr:@"" thumImage:nil];
            webObje.webpageUrl = message;
            messageObject.shareObject = webObje;            
        } else {
            messageObject.text = message;
        }

        if (type == UMSocialPlatformType_UserDefine_Begin) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = message;
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"COPY_SUCCESS")];
        } else {
            [[UMSocialManager defaultManager] shareToPlatform:type
                                                messageObject:messageObject
                                        currentViewController:[UIViewController currentTopViewController]
                                                   completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
            }];
        }
    }
                                        failBlock:^(NSDictionary *info, UMSocialPlatformType type) {
        
    }
                                        completed:^(BOOL isShow) {
        
    }];
}

@end
