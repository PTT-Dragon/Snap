//
//  PublicWebViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublicWebViewController : UIViewController
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *sysAccount;
@property (nonatomic,copy) NSDictionary *productDic;
@property (nonatomic,assign) BOOL isHome;
@property (nonatomic,assign) BOOL isChat;
@property (nonatomic,assign) BOOL isCategory;
@property (nonatomic,assign) BOOL shouldBackToHome;
@property (nonatomic,strong) MessageModel *model;//消息model
@property (nonatomic,weak) UIViewController *pushVc;//记录原始vc,点击返回直接pop 到该vc

@end

NS_ASSUME_NONNULL_END
