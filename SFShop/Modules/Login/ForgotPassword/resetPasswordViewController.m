//
//  resetPasswordViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "resetPasswordViewController.h"
#import "verifyCodeVC.h"
#import "UITextField+expand.h"

@interface resetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation resetPasswordViewController
static BOOL _accountSuccess = NO;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = kLocalizedString(@"Reset_password");
    [self.field addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.field.layer.borderWidth = 1;
    if (_type == 2) {
        _label.text = kLocalizedString(@"verification_email_code");
        _field.placeholder = kLocalizedString(@"Email");
        _explainLabel.text = kLocalizedString(@"EMAIL_ERROR_2");
        _label1.text = kLocalizedString(@"Email");
    }else{
        _label.text = kLocalizedString(@"RESET_PASSWORD_SMS");
        _field.placeholder = kLocalizedString(@"PHONE");
        _explainLabel.text = kLocalizedString(@"LOGIN_INVALID_PHONE");
        _label1.text = kLocalizedString(@"PHONE");
    }
}
- (void)changedTextField:(UITextField *)textField
{
    if (_type == 2) {
        _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:EIDTTYPE labels:@[_label1]];
    }else{
        _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:EIDTTYPE labels:@[_label1]];
    }
    if (_accountSuccess) {
        self.sendBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.sendBtn.userInteractionEnabled = YES;
    }else{
        self.sendBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.sendBtn.userInteractionEnabled = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_type == 2) {
        _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:BEGINEDITTYPE labels:@[_label1]];
    }else{
        _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:BEGINEDITTYPE labels:@[_label1]];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_type == 2) {
        _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:ENDEDITTYPE labels:@[_label1]];
    }else{
        _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:ENDEDITTYPE labels:@[_label1]];
    }
}
- (IBAction)sendAction:(UIButton *)sender {
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.check parameters:@{@"account":_field.text} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        if ([response[@"isExisting"] isEqualToString:@"1"]) {
            //已注册
            verifyCodeVC *vc = [[verifyCodeVC alloc] init];
            vc.account = weakself.field.text;
            vc.type = Forget_Code;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"ACCOUNT_DOES_NOT_EXIST")];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"error"]];
    }];
}


@end
