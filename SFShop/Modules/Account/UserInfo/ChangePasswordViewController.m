//
//  ChangePasswordViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currentField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Change Password";
}
- (IBAction)changeAction:(id)sender {
    if (![_PasswordField.text isEqualToString:_confirmPassword.text]) {
        [MBProgressHUD autoDismissShowHudMsg:@"xxxx"];
        return;
    }
    if (![_PasswordField.text passwordTextCheck]) {
        
    }
    [SFNetworkManager post:SFNet.account.pwdModify parameters:@{@"newPwd":_PasswordField.text,@"oldPwd":_currentField.text} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}


@end
