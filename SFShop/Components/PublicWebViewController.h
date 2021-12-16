//
//  PublicWebViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublicWebViewController : UIViewController
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *sysAccount;
@property (nonatomic,assign) BOOL isHome;

@end

NS_ASSUME_NONNULL_END
