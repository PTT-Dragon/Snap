//
//  SignUpViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "SignUpViewController.h"
#import "verifyCodeVC.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordQesLabel;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Sign Up";
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
    if (![_PhoneField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]) {
        [_signUpBtn setBackgroundColor:RGBColorFrom16(0xFF1659)];
    }else{
        [_signUpBtn setBackgroundColor:RGBColorFrom16(0xFFE5EB)];
    }
    if (textField == _passwordField) {
        if (![self.passwordField.text passwordTextCheck]) {
            _passwordField.layer.borderColor = RGBColorFrom16(0xC40000).CGColor;
            [_signUpBtn setBackgroundColor:RGBColorFrom16(0xFFE5EB)];
            _passwordQesLabel.textColor = RGBColorFrom16(0xFFE5EB);
            _signUpBtn.userInteractionEnabled = NO;
        }else{
            _passwordField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
            _passwordQesLabel.textColor = RGBColorFrom16(0x7b7b7b);
            _signUpBtn.userInteractionEnabled = YES;
        }
    }else if (textField == _PhoneField){
        
    }
}
- (IBAction)signUpAction:(id)sender {
    if ([_PhoneField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        
        return;
    }
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
            [MBProgressHUD autoDismissShowHudMsg:@"账号已经存在"];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
