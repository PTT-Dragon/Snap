//
//  LoginViaOTP.m
//  SFShop
//
//  Created by 游挺 on 2021/9/25.
//

#import "LoginViaOTP.h"
#import "verifyCodeVC.h"
#import "UITextField+expand.h"
#import "PublicAlertView.h"


@interface LoginViaOTP ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic,strong) UIView *lfView;
@end

@implementation LoginViaOTP
static BOOL _accountSuccess = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Login");
    self.titleLabel.text = kLocalizedString(@"LOGIN_VIA_OPT");
    [self.field addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    _label1.text = kLocalizedString(@"PHONE_NUMBER");
    _field.placeholder = kLocalizedString(@"PHONE_NUMBER");
    [self.btn setTitle:kLocalizedString(@"Login") forState:0];
    UIImage *im = [UIImage imageNamed:@"WX20220203-135232"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    _lfView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    iv.center = _lfView.center;
    [_lfView addSubview:iv];
    _field.leftViewMode = UITextFieldViewModeAlways;
    _field.leftView = _lfView;
}
-(void)changedTextField:(UITextField *)textField
{
    _accountSuccess = [textField systemPhoneCheck:CHECKPHONETYPE editType:ENDEDITTYPE];
    
    if (_accountSuccess) {
        self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.btn.userInteractionEnabled = YES;
        self.label1.hidden = NO;
        self.label2.hidden = YES;
        self.label2.textColor = RGBColorFrom16(0xff1659);
        self.label1.textColor = RGBColorFrom16(0xf7f7f7);
    }else{
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.label2.textColor = RGBColorFrom16(0xff1659);
        self.label1.textColor = RGBColorFrom16(0xff1659);
        self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.btn.userInteractionEnabled = NO;
    }
    if ([textField.text isEqualToString:@""]) {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
    }
}
- (IBAction)sendAction:(id)sender {
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.check parameters:@{@"account":_field.text} success:^(id  _Nullable response) {
        if ([response[@"isExisting"] isEqualToString:@"1"]) {
            //未注册
            verifyCodeVC *vc = [[verifyCodeVC alloc] init];
            vc.account = weakself.field.text;
            vc.type = LoginType_Code;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            weakself.btn.userInteractionEnabled = NO;
            weakself.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"ACCOUNT_DOES_NOT_EXIST")];
//            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"IS_ALREADY_REGISTERED")];
//            BOOL isEmail = [self.field.text rangeOfString:@"@"].location != NSNotFound;
//            NSString *str = isEmail ? [NSString stringWithFormat:@"%@%@",kLocalizedString(@"THIS_EMAIL_ADDRESS"),kLocalizedString(@"IS_ALREADY_REGISTERED")]: [NSString stringWithFormat:@"%@%@",kLocalizedString(@"THIS_PHONE_NUMBER"),kLocalizedString(@"IS_ALREADY_REGISTERED")];
//            PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:str btnTitle:kLocalizedString(@"Login") block:^{
//                [weakself.navigationController popViewControllerAnimated:YES];
//            } btn2Title:kLocalizedString(@"CANCEL") block2:^{
//
//            }];
//            [self.view addSubview:alert];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
