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
            
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)login
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":_account,@"code":login_aes_128_cbc_encrypt(_codeView.code)} success:^(id  _Nullable response) {
        NSError *error = nil;
        [[FMDBManager sharedInstance] deleteUserData];
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:@"hxf01@qq.com"];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
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
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.userInfo parameters:@{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_password),@"code":_codeView.code,@"captcha":@""} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"Sign Up Success!"];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)forgetPassword
{
    
}
- (IBAction)recendAction:(UIButton *)sender {
    [self getCode];
}


@end
