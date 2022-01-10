//
//  ChangePasswordViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "ChangePasswordViewController.h"
#import "UITextField+expand.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currentField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation ChangePasswordViewController
static BOOL _passwordSuccess1 = NO;
static BOOL _passwordSuccess2 = NO;
static BOOL _passwordSuccess3 = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Change_Password");
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    self.btn.userInteractionEnabled = NO;
    self.currentField.layer.borderWidth = 1;
    self.PasswordField.layer.borderWidth = 1;
    self.confirmPassword.layer.borderWidth = 1;
    [self.confirmPassword addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.PasswordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.currentField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == _currentField) {
        _passwordSuccess1 = [textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_label1]];
    }else if(textField == _PasswordField){
        _passwordSuccess2 = [textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_label2]];
    }else{
        _passwordSuccess3 = [textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[_label3]];
    }
    if (_passwordSuccess1 && _passwordSuccess2 && _passwordSuccess3) {
        self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.btn.userInteractionEnabled = YES;
    }else{
        self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.btn.userInteractionEnabled = NO;
    }
}
- (IBAction)changeAction:(id)sender {
    if (![_PasswordField.text isEqualToString:_confirmPassword.text]) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Confirm_password")];
        return;
    }
    [MBProgressHUD showHudMsg:@""];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [SFNetworkManager post:SFNet.account.pwdModify parameters:@{@"accessToken":model.accessToken,@"newPwd":_PasswordField.text,@"oldPwd":_currentField.text} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"error"]];
    }];
}


@end
