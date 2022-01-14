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

@interface verifyCodeVC ()<HWTFCodeBViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet HWTFCodeBView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *recendBtn;

@end

@implementation verifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _codeView.delegate = self;
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    self.contentLabel.text = [NSString stringWithFormat:@"Your code was sent to %@",_account ? _account: model.userRes.mobilePhone];
    [self getCode];
}
- (void)getCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_account) {
        [params setValue:_account forKey:@"account"];
    }else{
        [params setValue:@"false" forKey:@"isEmail"];
    }
    [params setValue:@"Terminal" forKey:@"userType"];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.getCode parameters:params success:^(id  _Nullable response) {
        [[CountDown sharedCountDown] countDown:120 andObject:weakself.recendBtn];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
//完成输入验证码
- (void)codeFinish
{
    //验证验证码
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.codeCheck parameters:@{@"account":_account,@"userType":@"Terminal",@"code":_codeView.code} success:^(id  _Nullable response) {
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
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)login
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":_account,@"code":login_aes_128_cbc_encrypt(_codeView.code)} success:^(id  _Nullable response) {
        NSError *error = nil;
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:weakself.account];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)cashOutAction
{
    [SFNetworkManager post:SFNet.distributor.createCashOut parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)signUp
{
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.userInfo parameters:@{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_password),@"code":_codeView.code,@"captcha":@""} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"Sign Up Success!"];
        [weakself toLogin];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
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
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)changeUserEmail
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.emailModify parameters:@{@"email":model.userRes.email,@"newEmail":_account,@"code":_codeView.code} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Modify_success")];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)recendAction:(UIButton *)sender {
    [self getCode];
}


@end
