//
//  MGCShareManager.m
//  SFShop
//
//  Created by Lufer on 2022/1/18.
//

#import "MGCShareManager.h"
#import "UIViewController+parentViewController.h"
#import "MGCShareView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TwitterKit.h>

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
    [MGCShareView showShareViewWithShareInfoModel:nil
                                     successBlock:^(NSDictionary *info, MGCShareType type) {
        if (type == MGCShareFacebookType) {
            [self shareToFaceBookWithMessage:message];
        } else if (type == MGCShareTwitterType) {
            [self shareToTwitterWithMessage:message];
        } else if (type == MGCShareWhatsAppType) {
            [self shareToWhatsAppWithMessage:message];
        } else if (type == MGCShareCopyLinkType) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = message;
        }
    }
                                        failBlock:nil
                                        completed:nil];
}


- (void)shareToFaceBookWithMessage:(NSString *)message {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    NSString *urlStr = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    content.contentURL = [NSURL URLWithString:urlStr];
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = [UIViewController currentTopViewController];
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeAutomatic;
    [dialog show];
}

- (void)shareToTwitterWithMessage:(NSString *)message {
    //检查是否当前会话具有登录的用户
    if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
        TWTRComposer *composer = [[TWTRComposer alloc] init];
        [composer setText:message];
        [composer showFromViewController:[UIViewController currentTopViewController]
                              completion:^(TWTRComposerResult result){
            if(result == TWTRComposerResultCancelled) {
                //分享失败
            } else {
                //分享成功
            }
        }];
    }else{
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                TWTRComposer *composer = [[TWTRComposer alloc] init];
                [composer setText:message];
                [composer showFromViewController:[UIViewController currentTopViewController]
                                      completion:^(TWTRComposerResult result){
                    if(result == TWTRComposerResultCancelled) {
                        //分享失败
                    } else {
                        //分享成功
                    }
                }];
                NSLog(@"signed in as %@", [session userName]);
            } else {
                NSLog(@"error: %@", [error localizedDescription]);
            }
        }];
    }
}

- (void)shareToWhatsAppWithMessage:(NSString *)message {
    NSString *url = [NSString stringWithFormat:@"whatsapp://send?text=%@", [message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSURL *whatsappURL = [NSURL URLWithString: url];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}




@end
