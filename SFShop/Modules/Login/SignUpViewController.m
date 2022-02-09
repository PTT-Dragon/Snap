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
    self.PhoneField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];//设置显示模式为永远显示(默认不显示)
    self.PhoneField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];//设置显示模式为永远显示(默认不显示)
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.passwordField.layer.borderWidth = 1;
    self.PhoneField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.PhoneField.layer.borderWidth = 1;
    [self.PhoneField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.accountQesLabel.text = kLocalizedString(@"PLEASE_INPUT_THE_CORRECT_PHONE_OR_EMAIL");
    _passwordField.placeholder = [NSString stringWithFormat:@"   %@",kLocalizedString(@"PASSWORD")];
    _PhoneField.placeholder = kLocalizedString(@"PHONE_NUMBER_EMAIL");
    _passwordLabel.text = [NSString stringWithFormat:@"%@",kLocalizedString(@"PASSWORD")];
    [self.signUpBtn setTitle:kLocalizedString(@"SIGN_UP") forState:0];
    self.phoneLabel.text = kLocalizedString(@"PHONE_NUMBER_EMAIL");
}
-(void)changedTextField:(UITextField *)textField
{
    if (textField == _PhoneField) {
        _accountSuccess = [textField systemPhoneCheck:CHECKMEAILORPHONE editType:EIDTTYPE];
        if ([textField.text isEqualToString:@""]) {
            _phoneLabel.hidden = YES;
            _accountQesLabel.hidden = YES;
            _accountQesLabel.textColor = RGBColorFrom16(0xf7f7f7);
        }
        if (_accountSuccess) {
            _phoneLabel.hidden = NO;
            _phoneLabel.textColor = RGBColorFrom16(0x7b7b7b);
            _accountQesLabel.hidden = YES;
        }else{
            _phoneLabel.hidden = NO;
            _phoneLabel.textColor = RGBColorFrom16(0xff1659);
            _accountQesLabel.hidden = NO;
            _accountQesLabel.textColor = RGBColorFrom16(0xff1659);
        }
    }else if (textField == _passwordField){
        _passwordSuccess = [textField systemPhoneCheck:CHECKPASSWORDTYPE editType:EIDTTYPE];
        if ([textField.text isEqualToString:@""]) {
            _passwordLabel.hidden = YES;
            _passwordQesLabel.hidden = NO;
            _passwordLabel.textColor = RGBColorFrom16(0xf7f7f7);
        }
        if (_passwordSuccess) {
            _passwordLabel.hidden = NO;
            _passwordLabel.textColor = RGBColorFrom16(0x7b7b7b);
            _passwordQesLabel.hidden = YES;
        }else{
            _passwordLabel.hidden = NO;
            _passwordLabel.textColor = RGBColorFrom16(0xff1659);
            _passwordQesLabel.hidden = NO;
            _passwordQesLabel.textColor = RGBColorFrom16(0xff1659);
        }
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
        if ([textField.text isEqualToString:@""]) {
            _phoneLabel.hidden = YES;
            _accountQesLabel.hidden = YES;
            _accountQesLabel.textColor = RGBColorFrom16(0xf7f7f7);
        }
    }else if (textField == _passwordField){
        if ([textField.text isEqualToString:@""]) {
            _passwordLabel.hidden = YES;
            _passwordQesLabel.hidden = YES;
            _passwordLabel.textColor = RGBColorFrom16(0xf7f7f7);
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _PhoneField) {
        if ([textField.text isEqualToString:@""]) {
            _phoneLabel.hidden = YES;
            _accountQesLabel.hidden = YES;
            _accountQesLabel.textColor = RGBColorFrom16(0xf7f7f7);
        }
    }else if (textField == _passwordField){
        if ([textField.text isEqualToString:@""]) {
            _passwordLabel.hidden = YES;
            _passwordQesLabel.hidden = NO;
            _passwordLabel.textColor = RGBColorFrom16(0xf7f7f7);
        }
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
            NSString *str = isEmail ? [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"THIS_EMAIL_ADDRESS"),kLocalizedString(@"IS_ALREADY_REGISTERED")]: [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"THIS_PHONE_NUMBER"),kLocalizedString(@"IS_ALREADY_REGISTERED")];
            PublicAlertView *alert = [[PublicAlertView alloc] initDarkColorWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:str btnTitle:kLocalizedString(@"CANCEL") block:^{
                
            } btn2Title:kLocalizedString(@"Login") block2:^{
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
            [self.view addSubview:alert];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
