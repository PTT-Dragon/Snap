//
//  ResetPasswordDoViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ResetPasswordDoViewController.h"

@interface ResetPasswordDoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation ResetPasswordDoViewController
- (BOOL)shouldCheckLoggedIn
{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Reset Password";
    [_pwdField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [_confirmPwdField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
}
- (void)tfEditingChanged:(UITextField *)field
{
    if (![_pwdField.text isEqualToString:@""] && ![_confirmPwdField.text isEqualToString:@""]) {
        _resetBtn.backgroundColor = RGBColorFrom16(0xFF1659);
    }else{
        _resetBtn.backgroundColor = RGBColorFrom16(0xFFe5eb);
    }
}
- (IBAction)resetAction:(UIButton *)sender {
    if (![_pwdField.text isEqualToString:_confirmPwdField.text]) {
        [MBProgressHUD autoDismissShowHudMsg:@"Confirm password"];
        return;
    }
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.resetPwd parameters:@{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_pwdField.text),@"code":_code,@"confirmPwd":login_aes_128_cbc_encrypt(_confirmPwdField.text)} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"Reset Success!"];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
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
