//
//  MGCShareManager.m
//  SFShop
//
//  Created by Lufer on 2022/1/18.
//

#import "MGCShareManager.h"
#import <UShareUI/UShareUI.h>
#import "UIViewController+parentViewController.h"

@implementation MGCShareManager

+ (instancetype)sharedInstance {
    static MGCShareManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MGCShareManager alloc] init];
    });
    return manager;
}

+ (void)shareWithShareInfoModel:(MGCShareInfoModel *)infoModel shareType:(MGCShareItemType)type {
    
}

- (void)showShareViewWithShareMessage:(NSString *)message {
    //调用分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Facebook),@(UMSocialPlatformType_Whatsapp),@(UMSocialPlatformType_Instagram)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,NSDictionary*userInfo){
        // 根据获取的platformType确定所选平台进行下一步操作
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.text = message;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[UIViewController currentTopViewController] completion:^(id data, NSError *error) {
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
    }];
}



@end
