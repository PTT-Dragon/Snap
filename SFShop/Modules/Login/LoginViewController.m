//
//  LoginViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "forgotPasswordView.h"
#import "LoginViaOTP.h"
#import "UITextField+expand.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIView *emailIndicationView;
@property (weak, nonatomic) IBOutlet UIView *phoneIndicationView;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *secureBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic,assign) NSInteger type;//登录方式   1.手机登录  2.邮箱登录

@end

@implementation LoginViewController
static BOOL _accountSuccess = NO;
static BOOL _passwordSuccess = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Login");
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    _type = 1;
    self.loginBtn.userInteractionEnabled = NO;
    self.passwordField.layer.borderWidth = 1;
    self.accountField.layer.borderWidth = 1;
    [self.passwordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == _accountField) {
        if (_type == 1) {
            _accountSuccess = [textField textFieldState:CHECKPHONETYPE labels:@[_label1]];
        }else{
            _accountSuccess = [textField textFieldState:CHECKEMAILTYPE labels:@[_label1]];
        }
    }else{
        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE labels:@[_label2]];
    }
    if (_accountSuccess && _passwordSuccess) {
        self.loginBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.loginBtn.userInteractionEnabled = YES;
    }else{
        self.loginBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.loginBtn.userInteractionEnabled = NO;
    }
}
- (IBAction)phoneAction:(UIButton *)sender {
    _type = 1;
    sender.selected = YES;
    _emailBtn.selected = NO;
    _phoneIndicationView.backgroundColor = [UIColor blackColor];
    _emailIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _label1.text = kLocalizedString(@"Phone_number");
    _accountField.placeholder = kLocalizedString(@"Phone_number");
}
- (IBAction)emailAction:(UIButton *)sender {
    _type = 2;
    sender.selected = YES;
    _phoneBtn.selected = NO;
    _phoneIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _emailIndicationView.backgroundColor = [UIColor blackColor];
    _label1.text = kLocalizedString(@"Email");
    _accountField.placeholder = kLocalizedString(@"Email");
}
- (IBAction)loginAction:(id)sender {
    //wcttest1@qq.com/smart123  17366287044 Abc@1234  rx_dadoubi@sina.com/Abc@12345    A1customer@A1.com/Abc@1234
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":_accountField.text,@"pwd":login_aes_128_cbc_encrypt(_passwordField.text)} success:^(id  _Nullable response) {
        NSError *error = nil;
//        [[FMDBManager sharedInstance] deleteUserData];
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:weakself.accountField.text];
        if (weakself.didLoginBlock)  {
            weakself.didLoginBlock();
        }
    } failed:^(NSError * _Nonnull error) {
        weakself.loginBtn.userInteractionEnabled = NO;
        weakself.loginBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)signUpAction:(id)sender {
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)forgotAction:(id)sender {
    forgotPasswordView *view = [[NSBundle mainBundle] loadNibNamed:@"forgotPasswordView" owner:self options:nil].firstObject;
    view.type = resetType;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    [self.view addSubview:view];
}
- (IBAction)otpAction:(id)sender {
    LoginViaOTP *vc = [[LoginViaOTP alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)secureAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordField.secureTextEntry = sender.selected;
}


@end
