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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Login";
    [self.passwordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changedTextField:(UITextField *)textField
{
    if (![_passwordField.text isEqualToString:@""] && ![_accountField.text isEqualToString:@""]) {
        self.loginBtn.backgroundColor = RGBColorFrom16(0xFF1659);
    }else{
        self.loginBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
    }
}
- (IBAction)phoneAction:(UIButton *)sender {
    sender.selected = YES;
    _emailBtn.selected = NO;
    _phoneIndicationView.backgroundColor = [UIColor blackColor];
    _emailIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _label1.text = @" Phone number ";
}
- (IBAction)emailAction:(UIButton *)sender {
    sender.selected = YES;
    _phoneBtn.selected = NO;
    _phoneIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _emailIndicationView.backgroundColor = [UIColor blackColor];
    _label1.text = @" Email ";
}
- (IBAction)loginAction:(id)sender {
    //wcttest1@qq.com/smart123  17366287044 Abc@1234
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":_accountField.text,@"pwd":login_aes_128_cbc_encrypt(_passwordField.text)} success:^(id  _Nullable response) {
        NSError *error = nil;
        [[FMDBManager sharedInstance] deleteUserData];
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:weakself.accountField.text];
        if (weakself.didLoginBlock)  {
            weakself.didLoginBlock();
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)signUpAction:(id)sender {
    SignUpViewController *vc = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)forgotAction:(id)sender {
    forgotPasswordView *view = [[NSBundle mainBundle] loadNibNamed:@"forgotPasswordView" owner:self options:nil].firstObject;
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
