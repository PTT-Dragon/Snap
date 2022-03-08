//
//  ResetPasswordDoViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ResetPasswordDoViewController.h"
#import "UITextField+expand.h"

@interface ResetPasswordDoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation ResetPasswordDoViewController
static BOOL _passwordSuccess1 = NO;
static BOOL _passwordSuccess2 = NO;

- (BOOL)shouldCheckLoggedIn
{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"CHANGE_PASS");
    _pwdField.layer.borderWidth = 1;
    _confirmPwdField.layer.borderWidth = 1;
    [_pwdField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [_confirmPwdField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
}
- (void)tfEditingChanged:(UITextField *)field
{
    if (field == _pwdField) {
        _passwordSuccess1 = [field textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_label1,_label2]] && [field.text isEqualToString:_confirmPwdField.text];
    }else{
        _passwordSuccess2 = [field textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_label3,_label4]]  && [field.text isEqualToString:_pwdField.text];
    }
    if (_passwordSuccess2 && _passwordSuccess1) {
        self.resetBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.resetBtn.userInteractionEnabled = YES;
    }else{
        self.resetBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.resetBtn.userInteractionEnabled = NO;
    }
    
}
- (IBAction)resetAction:(UIButton *)sender {
    if (![_pwdField.text isEqualToString:_confirmPwdField.text]) {
        [MBProgressHUD showTopErrotMessage:kLocalizedString(@"Confirm_password")];
        return;
    }
    //[MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.resetPwd parameters:@{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_pwdField.text),@"code":_code,@"confirmPwd":login_aes_128_cbc_encrypt(_confirmPwdField.text)} success:^(id  _Nullable response) {
        [weakself.navigationController popToRootViewControllerAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Reset_success")];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"error"]];
    }];
}

- (IBAction)btn1Action:(UIButton *)sender {
    sender.selected = !sender.selected;
    _pwdField.secureTextEntry = sender.selected;
}
- (IBAction)btn2Action:(UIButton *)sender {
    sender.selected = !sender.selected;
    _confirmPwdField.secureTextEntry = sender.selected;
}

@end
