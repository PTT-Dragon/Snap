//
//  verifyCodeVC.h
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoginType_Code = 0,
    CashOut_Code = 1,
    ChangeMobileNumber_Code = 2,
    ChangeEmail_Code = 3,
    SignUp_Code = 4,
    Forget_Code = 5,
    
} LoginType;

NS_ASSUME_NONNULL_BEGIN

@interface verifyCodeVC : UIViewController
@property (nonatomic,strong) NSDictionary *cashOutInfoDic;//提现资料
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,assign) LoginType type;
@end

NS_ASSUME_NONNULL_END
