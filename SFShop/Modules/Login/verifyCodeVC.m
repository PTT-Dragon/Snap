//
//  verifyCodeVC.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "verifyCodeVC.h"
#import "HWTFCodeBView.h"
#import "AES128Util.h"
#import "CountDown.h"
#import "ResetPasswordDoViewController.h"
#import "LoginViewController.h"
#import "SysParamsModel.h"
#import <MJRefresh/MJRefresh.h>
#import "CashOutSuccessVC.h"

@interface verifyCodeVC ()<HWTFCodeBViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet HWTFCodeBView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *recendBtn;
@property (nonatomic, strong) dispatch_source_t timer;//倒计时
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation verifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _codeView.delegate = self;
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"YOUR_CODE_WAS_SENT_TO"),_account ? _account: model.userRes.mobilePhone];
    [self.recendBtn setTitle:kLocalizedString(@"RESEND") forState:0];
    self.titleLabel.text = _type == BindEmail_Code ? kLocalizedString(@"BIND_EMAIL"): kLocalizedString(@"ENTER_CODE");
    [self getCode];
}
- (void)getCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type == ChangeEmail_Code) {
        [params setValue:@"true" forKey:@"isEmail"];
        [params setValue:@"" forKey:@"account"];
    }else if (_type == SignUp_Code){
        [params setValue:_account forKey:@"account"];
    }else if (_type == BindEmail_Code){
        [params setValue:_account forKey:@"account"];
        [params setValue:@"false" forKey:@"isEmail"];
    }else if (_account) {
        [params setValue:_account forKey:@"account"];
    }else{
        [params setValue:@"false" forKey:@"isEmail"];
    }
    if (_password && _type != SignUp_Code) {
        //需加入密码验证.
        [params setValue:login_aes_128_cbc_encrypt(_password) forKey:@"pwd"];
    }
//    [params setValue:@"Terminal" forKey:@"userType"];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.getCode parameters:params success:^(id  _Nullable response) {
        weakself.recendBtn.userInteractionEnabled = NO;
        weakself.recendBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        [weakself showCountLabel];
    } failed:^(NSError * _Nonnull error) {
        weakself.recendBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)showCountLabel
{
    _countdownLabel.hidden = NO;
    //倒计时
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    MPWeakSelf(self)
//    SysParamsItemModel *model = [SysParamsItemModel sharedSysParamsItemModel];
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CODE_TTL.intValue;
    __block NSInteger timeout = precision *60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            
            dispatch_source_cancel(weakself.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.recendBtn.backgroundColor = RGBColorFrom16(0xFF1659);
                weakself.recendBtn.userInteractionEnabled = YES;
                weakself.countdownLabel.hidden = YES;
            });
        }else{
            NSInteger days = (int)(timeout/(3600*24));
            NSInteger hours = (int)((timeout-days*24*3600)/3600);
            NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
            NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.countdownLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld:%02ld",kLocalizedString(@"RESEND_CODE_IN"),hours,minute,second];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//完成输入验证码
- (void)codeFinish
{
    //验证验证码
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type == ChangeEmail_Code) {
        [params setValue:@"true" forKey:@"isEmail"];
        [params setValue:_codeView.code forKey:@"code"];
    }else if (_type == CashOut_Code){
        [params setValue:@"false" forKey:@"isEmail"];
        [params setValue:_codeView.code forKey:@"code"];
    }else{
        [params setValue:_codeView.code forKey:@"code"];
        [params setValue:@"Terminal" forKey:@"userType"];
        [params setValue:_account forKey:@"account"];
    }
    [SFNetworkManager post:SFNet.account.codeCheck parameters:params success:^(id  _Nullable response) {
        if (weakself.type == LoginType_Code) {
            [weakself login];
        }else if (weakself.type == CashOut_Code){
            //提现
            [weakself cashOutAction];
        }else if (weakself.type == SignUp_Code){
            [weakself signUp];
        }else if (weakself.type == Forget_Code){
            [weakself forgetPassword];
        }else if (weakself.type == ChangeMobileNumber_Code){
            [weakself changeUserPhone];
        }else if (weakself.type == ChangeEmail_Code){
            [weakself changeUserEmail];
        }else if (weakself.type == BindEmail_Code){
            [weakself bindUserEmail];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)login
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":_account,@"code":_codeView.code} success:^(id  _Nullable response) {
        NSError *error = nil;
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:weakself.account];
        if (model.userRes.defLangCode) {
            MJRefreshConfig.defaultConfig.languageCode = model.userRes.defLangCode ? model.userRes.defLangCode: @"id";
            if ([model.userRes.defLangCode isEqualToString:@"zh"]) {
                UserDefaultSetObjectForKey(kLanguageChinese, @"Language");
                [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageChinese];
            } else {
                UserDefaultSetObjectForKey(model.userRes.defLangCode, @"Language");
                [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:model.userRes.defLangCode];
            }
        }else{
            MJRefreshConfig.defaultConfig.languageCode = @"id";
            UserDefaultSetObjectForKey(@"id", @"Language");
            [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:@"id"];
        }
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.tabVC setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)cashOutAction
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.distributor.createCashOut parameters:_withdrawInfo success:^(id  _Nullable response) {
        CashOutSuccessVC *vc = [[CashOutSuccessVC alloc] init];
        [weakself.navigationController pushViewController:vc animated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)signUp
{
    //[MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.userInfo parameters:@{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_password),@"code":_codeView.code,@"captcha":@""} success:^(id  _Nullable response) {
//        [MBProgressHUD autoDismissShowHudMsg:@"Sign Up Success!"];
        [weakself loginBySign];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)loginBySign
{
    MPWeakSelf(self)
    NSDictionary *param = @{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_password)};
    [SFNetworkManager post:SFNet.account.login parameters:param success:^(id  _Nullable response) {
        NSError *error = nil;
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:weakself.account];
        if (model.userRes.defLangCode) {
            MJRefreshConfig.defaultConfig.languageCode = model.userRes.defLangCode ? model.userRes.defLangCode: @"id";
            if ([model.userRes.defLangCode isEqualToString:@"zh"]) {
                UserDefaultSetObjectForKey(kLanguageChinese, @"Language");
                [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageChinese];
            } else {
                UserDefaultSetObjectForKey(model.userRes.defLangCode, @"Language");
                [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:model.userRes.defLangCode];
            }
        }else{
            MJRefreshConfig.defaultConfig.languageCode = @"id";
            UserDefaultSetObjectForKey(@"id", @"Language");
            [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:@"id"];
        }
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.tabVC setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"SIGN_TO_LOGIN")];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)forgetPassword
{
    ResetPasswordDoViewController *vc = [[ResetPasswordDoViewController alloc] init];
    vc.code = _codeView.code;
    vc.account = _account;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toLogin
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
        }
    }];
}
- (void)changeUserPhone
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.phoneModify parameters:@{@"code":_codeView.code,@"newMobilePhone":_account,@"pwd":login_aes_128_cbc_encrypt(_password)} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Modify_success")];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)changeUserEmail
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:model.userRes.email forKey:@"email"];
    [params setValue:_account forKey:@"newEmail"];
    [params setValue:_codeView.code forKey:@"code"];
    [SFNetworkManager post:SFNet.account.emailModify parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Modify_success")];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)bindUserEmail
{
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_account forKey:@"email"];
    [params setValue:@"Terminal" forKey:@"userType"];
    [params setValue:_codeView.code forKey:@"code"];
    [SFNetworkManager post:SFNet.account.bindEmail parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Modify_success")];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)recendAction:(UIButton *)sender {
    [self getCode];
}


@end
