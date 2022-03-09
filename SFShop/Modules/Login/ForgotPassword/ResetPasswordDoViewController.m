//
//  ResetPasswordDoViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ResetPasswordDoViewController.h"
#import "UITextField+expand.h"
#import "SysParamsModel.h"
#import "NSString+Fee.h"
#import <MJRefresh/MJRefresh.h>

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
    _label1.text = kLocalizedString(@"NEW_PASSWORD");
    _pwdField.placeholder = kLocalizedString(@"NEW_PASSWORD");
    _label3.text = kLocalizedString(@"RE_ENTER_NEW_PASSWORD");
    _confirmPwdField.placeholder = kLocalizedString(@"RE_ENTER_NEW_PASSWORD");
    _label4.text = kLocalizedString(@"PASSWORD_NOT_MATCH");
    [_resetBtn setTitle:kLocalizedString(@"RESET") forState:0];
    [self loadDatas];
}
- (void)loadDatas
{
    [SFNetworkManager get:SFNet.account.pwdpolicy parameters:@{} success:^(id  _Nullable response) {
        SysParamsItemModel *model = [SysParamsItemModel sharedSysParamsItemModel];
        model.PASSWORD_REGULAR_RULE = response[@"pwdComplexRegRule"];
        self.label2.text = [NSString stringWithFormat:@"%@-%@,%@",response[@"minPwdLen"],response[@"maxPwdLen"],response[@"pwdComplexMark"]];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)tfEditingChanged:(UITextField *)field
{
    if (field == _pwdField) {
        _passwordSuccess1 = [field.text validatePassword];
    }else{
        _passwordSuccess2 = [field.text isEqualToString:_pwdField.text];
    }
    if (!_passwordSuccess1) {
        _pwdField.layer.borderColor = RGBColorFrom16(0xCE0000).CGColor;
        _label1.hidden = NO;
        _label2.hidden = NO;
        _label1.textColor = RGBColorFrom16(0xCE0000);
        _label2.textColor = RGBColorFrom16(0xCE0000);
    }else{
        _pwdField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
        _label1.textColor = RGBColorFrom16(0x7b7b7b);
        _label2.textColor = RGBColorFrom16(0x7b7b7b);
        _label2.hidden = YES;
    }
    if (!_passwordSuccess2) {
        if (field == _confirmPwdField) {
            _confirmPwdField.layer.borderColor = RGBColorFrom16(0xCE0000).CGColor;
            _label3.hidden = NO;
            _label4.hidden = NO;
            _label3.textColor = RGBColorFrom16(0xCE0000);
            _label4.textColor = RGBColorFrom16(0xCE0000);
        }
    }else{
        _confirmPwdField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
        _label3.textColor = RGBColorFrom16(0x7b7b7b);
        _label4.textColor = RGBColorFrom16(0x7b7b7b);
        _label4.hidden = YES;
    }
    _label1.hidden = [_pwdField.text isEqualToString:@""];
    _label3.hidden = [_confirmPwdField.text isEqualToString:@""];
    if (_passwordSuccess2 && _passwordSuccess1) {
        self.resetBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.resetBtn.userInteractionEnabled = YES;
    }else{
        self.resetBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.resetBtn.userInteractionEnabled = NO;
    }
    
}
- (void)logoutAction
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.logout success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"LogOut Success"];
        UserDefaultSetObjectForKey(kLanguageHindi, @"Language");
        MJRefreshConfig.defaultConfig.languageCode = @"id";
        [[FMDBManager sharedInstance] deleteUserData];
        [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageHindi];
        [baseTool removeVCFromNavigation:weakself];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)resetAction:(UIButton *)sender {
    if (![_pwdField.text isEqualToString:_confirmPwdField.text]) {
        [MBProgressHUD showTopErrotMessage:kLocalizedString(@"Confirm_password")];
        return;
    }
    //[MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.resetPwd parameters:@{@"account":_account,@"pwd":login_aes_128_cbc_encrypt(_pwdField.text),@"code":_code,@"confirmPwd":login_aes_128_cbc_encrypt(_confirmPwdField.text)} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"RESET_SUCCESSFULLY_PLEASE_RE_LOGIN")];
        [weakself performSelector:@selector(logoutAction) withObject:nil afterDelay:1];
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
