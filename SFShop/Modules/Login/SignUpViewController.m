//
//  SignUpViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "SignUpViewController.h"
#import "verifyCodeVC.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Sign Up";
    [self.PhoneField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
-(void)changedTextField:(UITextField *)textField
{
    if (![_PhoneField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]) {
        [_signUpBtn setBackgroundColor:RGBColorFrom16(0xFF1659)];
    }else{
        [_signUpBtn setBackgroundColor:RGBColorFrom16(0xFFE5EB)];
    }
}
- (IBAction)signUpAction:(id)sender {
    //q1Q-
    if ([_PhoneField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        return;
    }
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.check parameters:@{@"account":_PhoneField.text} success:^(id  _Nullable response) {
        if ([response[@"isExisting"] isEqualToString:@"0"]) {
            //未注册
            verifyCodeVC *vc = [[verifyCodeVC alloc] init];
            vc.account = weakself.PhoneField.text;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)loginAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
