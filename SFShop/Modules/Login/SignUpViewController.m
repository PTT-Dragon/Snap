//
//  SignUpViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "SignUpViewController.h"
#import "verifyCodeVC.h"
#import "UITextField+expand.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordQesLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountQesLabel;

@end

@implementation SignUpViewController
static BOOL _accountSuccess = NO;
static BOOL _passwordSuccess = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Sign_Up");
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    self.passwordField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.passwordField.layer.borderWidth = 1;
    self.PhoneField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.PhoneField.layer.borderWidth = 1;
    [self.PhoneField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
-(void)changedTextField:(UITextField *)textField
{
    if (textField == _PhoneField) {
        _accountSuccess = [textField textFieldState:CHECKPHONETYPE || CHECKEMAILTYPE labels:@[_phoneLabel,_accountQesLabel]];
    }else if (textField == _passwordField){
        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE labels:@[_passwordLabel,_passwordQesLabel]];
    }
    if (_accountSuccess && _passwordSuccess) {
        self.signUpBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.signUpBtn.userInteractionEnabled = YES;
    }else{
        self.signUpBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.signUpBtn.userInteractionEnabled = NO;
    }
}
- (IBAction)signUpAction:(id)sender {
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.check parameters:@{@"account":_PhoneField.text} success:^(id  _Nullable response) {
        if ([response[@"isExisting"] isEqualToString:@"0"]) {
            //未注册
            verifyCodeVC *vc = [[verifyCodeVC alloc] init];
            vc.account = weakself.PhoneField.text;
            vc.type = SignUp_Code;
            vc.password = weakself.passwordField.text;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            weakself.signUpBtn.userInteractionEnabled = NO;
            self.signUpBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"IS_ALREADY_REGISTERED")];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
