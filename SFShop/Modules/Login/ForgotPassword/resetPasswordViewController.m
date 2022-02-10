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
@property (nonatomic,strong) UIView *lfView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation resetPasswordViewController
static BOOL _accountSuccess = NO;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = kLocalizedString(@"CHANGE_PASS");
    [self.field addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.field.layer.borderWidth = 1;
    self.field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];
    self.field.leftViewMode = UITextFieldViewModeAlways;
    if (_type == 2) {
        _label.text = kLocalizedString(@"RESET_PASSWORD_EMAIL");
        _field.placeholder = kLocalizedString(@"Email");
        _explainLabel.text = kLocalizedString(@"INCORRECT_EMAIL");
        _label1.text = kLocalizedString(@"Email");
        
    }else{
        _label.text = kLocalizedString(@"RESET_PASSWORD_SMS");
        _field.placeholder = kLocalizedString(@"PHONE_NUMBER");
        _explainLabel.text = kLocalizedString(@"INCORRECT_PHONE");
        _label1.text = kLocalizedString(@"PHONE_NUMBER");
        UIImage *im = [UIImage imageNamed:@"WX20220203-135232"];
        UIImageView *iv = [[UIImageView alloc] initWithImage:im];
        _lfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
        iv.center = _lfView.center;
        [_lfView addSubview:iv];
        _field.leftViewMode = UITextFieldViewModeAlways;
        _field.leftView = _lfView;
    }
}
- (void)changedTextField:(UITextField *)textField
{
    if (_type == 2) {
        _accountSuccess = [textField systemPhoneCheck:CHECKEMAILTYPE editType:EIDTTYPE];
    }else{
        _accountSuccess = [textField systemPhoneCheck:CHECKPHONETYPE editType:EIDTTYPE];
    }
    if (_accountSuccess) {
        self.sendBtn.backgroundColor = RGBColorFrom16(0xff1659);
        self.sendBtn.userInteractionEnabled = YES;
        self.label1.textColor = RGBColorFrom16(0x7b7b7b);
        self.explainLabel.textColor = RGBColorFrom16(0x7b7b7b);
    }else{
        self.sendBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.sendBtn.userInteractionEnabled = NO;
        self.label1.hidden = NO;
        self.explainLabel.hidden = NO;
        self.label1.textColor = RGBColorFrom16(0xCE0000);
        self.explainLabel.textColor = RGBColorFrom16(0xCE0000);
    }
    if ([textField.text isEqualToString:@""]) {
        self.label1.hidden = YES;
        self.explainLabel.hidden = YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.label1.hidden = YES;
        self.explainLabel.hidden = YES;
    }
//    if (_type == 2) {
//        _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:BEGINEDITTYPE labels:@[_label1]];
//    }else{
//        _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:BEGINEDITTYPE labels:@[_label1]];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.label1.hidden = YES;
        self.explainLabel.hidden = YES;
        self.field.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }
//    if (_type == 2) {
//        _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:ENDEDITTYPE labels:@[_label1]];
//    }else{
//        _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:ENDEDITTYPE labels:@[_label1]];
//    }
}
- (IBAction)sendAction:(UIButton *)sender {
    //[MBProgressHUD showHudMsg:@""];
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
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"error"]];
    }];
}


@end
