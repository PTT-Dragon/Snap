//
//  MGCShareManager.m
//  SFShop
//
//  Created by Lufer on 2022/1/18.
//

#import "MGCShareManager.h"
#import "UIViewController+parentViewController.h"
#import "MGCShareView.h"
#import <TwitterKit/TwitterKit.h>
#import "PosterView.h"

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
    __block NSString *url = message;
    [MGCShareView showShareViewWithShareInfoModel:nil posterModel:nil
                                     successBlock:^(NSDictionary *info, MGCShareType type) {
        if (type == MGCShareFacebookType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/F/"];
            }
            [self shareToFaceBookWithMessage:url];
        } else if (type == MGCShareTwitterType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/T/"];
            }
            [self shareToTwitterWithMessage:url];
        } else if (type == MGCShareWhatsAppType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/W/"];
            }
            [self shareToWhatsAppWithMessage:url];
        } else if (type == MGCShareCopyLinkType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/S/"];
            }
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = url;
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"COPY_SUCCESS")];
        } else if (type == MGCSharePosterType) {
            
            
        }
    }
                                        failBlock:nil
                                        completed:nil];
}
- (void)showShareViewWithShareMessage:(NSString *)message posterModel:(NSArray <PosterPosterModel *> *)posterModelArr productModel:(DistributorRankProductModel *)productModel
{
    MGCShareInfoModel *infoModel = [[MGCShareInfoModel alloc] init];
    __block NSString *url = message;
    [MGCShareView showShareViewWithShareInfoModel:nil posterModel:posterModelArr
                                     successBlock:^(NSDictionary *info, MGCShareType type) {
        if (type == MGCShareFacebookType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/F/"];
            }
            [self shareToFaceBookWithMessage:url];
        } else if (type == MGCShareTwitterType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/T/"];
            }
            [self shareToTwitterWithMessage:url];
        } else if (type == MGCShareWhatsAppType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/W/"];
            }
            [self shareToWhatsAppWithMessage:url];
        } else if (type == MGCShareCopyLinkType) {
            if ([message rangeOfString:@"/F/"].location != NSNotFound) {
                url = [message stringByReplacingOccurrencesOfString:@"/F/" withString:@"/S/"];
            }
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = url;
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"COPY_SUCCESS")];
        } else if (type == MGCSharePosterType) {
            [MGCShareView showPosterViewWithShareInfoModel:nil posterModel:posterModelArr productModel:productModel successBlock:^(NSDictionary *info, MGCShareType type) {
                if (type == MGCShareSavePosterToFacebookType) {
                    [self shareToFaceBookWithMessage:message];
//                    [self shareToFacebookWithImage:info[@"image"]];
                }else if (type == MGCShareSavePosterToWhatsAppType){
                    [self shareToWhatsAppWithMessage:url];
//                    [self shareToWhatsAppWithImage:info[@"image"]];
                }
            } failBlock:^(NSDictionary *info, MGCShareType type) {
                
            } completed:^(BOOL isShow) {
                
            }];
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
- (void)shareToFacebookWithImage:(UIImage *)image
{
//    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//    NSString *urlStr = [@"http://47.243.193.90:8064/product/detail/4?campaignId=96&cmpType=8&distributorId=1007" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    content.contentURL = [NSURL URLWithString:urlStr];
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.fromViewController = [UIViewController currentTopViewController];
//    dialog.shareContent = content;
//    dialog.mode = FBSDKShareDialogModeAutomatic;
//    [dialog show];
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:YES];
    photo.caption = @"11";
    content.photos = @[photo];
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = [UIViewController currentTopViewController];
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeAutomatic;
    [dialog show];
//    [FBSDKShareDialog showFromViewController:[baseTool getCurrentVC] withContent:content delegate:self];

}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    
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
- (void)shareToWhatsAppWithImage:(UIImage *)image
{
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        
//        UIImage *image = [UIImage imageWithContentsOfFile:localpath];
        NSString *savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"whatsAppTmp.wai"];
        [UIImageJPEGRepresentation(image, 0.8) writeToFile:savePath atomically:YES];
         
        NSArray *activityItems = @[[NSURL fileURLWithPath:savePath]];
        UIActivityViewController *ctrl = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        ctrl.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
        [[baseTool getCurrentVC] presentViewController:ctrl animated:YES completion:nil];

         
//            NSString *savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
//
//            [UIImageJPEGRepresentation(image, 1.0) writeToFile:savePath atomically:YES];
//
//            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
//            _documentInteractionController.UTI = @"net.whatsapp.image";
//            _documentInteractionController.delegate = self;
//            [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:[baseTool getCurrentVC].view animated: YES];
        } else {
            
        }
}




@end
