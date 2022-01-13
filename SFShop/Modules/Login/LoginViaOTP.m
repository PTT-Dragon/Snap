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

@end

@implementation LoginViaOTP
static BOOL _accountSuccess = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.field addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
-(void)changedTextField:(UITextField *)textField
{
    _accountSuccess = [textField textFieldState:CHECKPHONETYPE || CHECKEMAILTYPE editType:EIDTTYPE labels:@[]];
    
    if (_accountSuccess) {
        self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.btn.userInteractionEnabled = YES;
    }else{
        self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.btn.userInteractionEnabled = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _accountSuccess = [textField textFieldState:CHECKPHONETYPE || CHECKEMAILTYPE editType:BEGINEDITTYPE labels:@[]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _accountSuccess = [textField textFieldState:CHECKPHONETYPE || CHECKEMAILTYPE editType:ENDEDITTYPE labels:@[]];
}
- (IBAction)sendAction:(id)sender {
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.check parameters:@{@"account":_field.text} success:^(id  _Nullable response) {
        if ([response[@"isExisting"] isEqualToString:@"0"]) {
            //未注册
            verifyCodeVC *vc = [[verifyCodeVC alloc] init];
            vc.account = weakself.field.text;
            vc.type = LoginType_Code;
            [weakself.navigationController pushViewController:vc animated:YES];
        }else{
            weakself.btn.userInteractionEnabled = NO;
            weakself.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"IS_ALREADY_REGISTERED")];
            BOOL isEmail = [self.field.text rangeOfString:@"@"].location != NSNotFound;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
