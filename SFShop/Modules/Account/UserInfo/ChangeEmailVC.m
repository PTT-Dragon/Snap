//
//  ChangeEmailVC.m
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import "ChangeEmailVC.h"
#import "NSString+Fee.h"

@interface ChangeEmailVC ()
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ChangeEmailVC
static BOOL _passwordSuccess1 = NO;

- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _label1.text = kLocalizedString(@"EMAIL");
    self.title = kLocalizedString(@"CHANGE_EMAIL");
    self.field.layer.borderWidth = 1;
    [_field addTarget:self action:@selector(changedTextField:) forControlEvents:(UIControlEventEditingChanged)];
    _field.placeholder = kLocalizedString(@"EMAIL");
    [self.btn setTitle:kLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
}
- (void)changedTextField:(UITextField *)textField
{
    _label1.hidden = [textField.text isEqualToString:@""];
    _label2.text = [textField.text isEqualToString:@""] ? kLocalizedString(@"REQUIREDTIP"): kLocalizedString(@"INCORRECT_EMAIL");
    _passwordSuccess1 = [textField.text validateEmail];
    if (_passwordSuccess1) {
        _label2.hidden = YES;
        _label1.textColor = RGBColorFrom16(0x7b7b7b);
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
        self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.btn.userInteractionEnabled = YES;
    }else{
        _label1.textColor = RGBColorFrom16(0xff1659);
        _label2.hidden = NO;
        textField.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
        self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.btn.userInteractionEnabled = NO;
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_field.text forKey:@"newEmail"];
    [params setValue:_code forKey:@"code"];
    [SFNetworkManager post:SFNet.account.emailModify parameters:params success:^(id  _Nullable response) {
        [baseTool removeVCFromNavigationWithVCNameArr:@[@"verifyCodeVC",@"ChangeMobileOrEmailViewController"] currentVC:self];
        [weakself.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"SET_SUCCESSFUL")];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

@end
