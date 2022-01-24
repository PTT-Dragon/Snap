//
//  SignUpViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "SignUpViewController.h"
#import "verifyCodeVC.h"
#import "UITextField+expand.h"
#import "PublicAlertView.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordQesLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountQesLabel;
@property (weak, nonatomic) IBOutlet UIButton *secureBtn;

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
        _accountSuccess = [textField textFieldState:CHECKMEAILORPHONE editType:EIDTTYPE labels:@[_phoneLabel,_accountQesLabel]];
    }else if (textField == _passwordField){
        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_passwordLabel,_passwordQesLabel]];
    }
    if (_accountSuccess && _passwordSuccess) {
        self.signUpBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.signUpBtn.userInteractionEnabled = YES;
    }else{
        self.signUpBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.signUpBtn.userInteractionEnabled = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _PhoneField) {
        _accountSuccess = [textField textFieldState:CHECKMEAILORPHONE editType:BEGINEDITTYPE labels:@[_phoneLabel]];
    }else if (textField == _passwordField){
        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:BEGINEDITTYPE labels:@[_passwordLabel]];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _PhoneField) {
        _accountSuccess = [textField textFieldState:CHECKMEAILORPHONE editType:ENDEDITTYPE labels:@[_phoneLabel]];
    }else if (textField == _passwordField){
        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:ENDEDITTYPE labels:@[_passwordLabel]];
    }
}
- (IBAction)secAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordField.secureTextEntry = sender.selected;
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
            weakself.signUpBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
            BOOL isEmail = [self.PhoneField.text rangeOfString:@"@"].location != NSNotFound;
            NSString *str = isEmail ? [NSString stringWithFormat:@"%@%@",kLocalizedString(@"THIS_EMAIL_ADDRESS"),kLocalizedString(@"IS_ALREADY_REGISTERED")]: [NSString stringWithFormat:@"%@%@",kLocalizedString(@"THIS_PHONE_NUMBER"),kLocalizedString(@"IS_ALREADY_REGISTERED")];
            PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:str btnTitle:kLocalizedString(@"Login") block:^{
                [weakself.navigationController popViewControllerAnimated:YES];
            } btn2Title:kLocalizedString(@"CANCEL") block2:^{
                
            }];
            [self.view addSubview:alert];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
