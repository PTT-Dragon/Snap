//
//  LoginViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "LoginViewController.h"
#import "AES128Util.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIView *emailIndicationView;
@property (weak, nonatomic) IBOutlet UIView *phoneIndicationView;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Login";
}
- (IBAction)phoneAction:(UIButton *)sender {
    sender.selected = YES;
    _emailBtn.selected = NO;
    _phoneIndicationView.backgroundColor = [UIColor blackColor];
    _emailIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
}
- (IBAction)emailAction:(UIButton *)sender {
    sender.selected = YES;
    _phoneBtn.selected = NO;
    _phoneIndicationView.backgroundColor = RGBColorFrom16(0xc4c4c4);
    _emailIndicationView.backgroundColor = [UIColor blackColor];
}
- (IBAction)loginAction:(id)sender {
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":@"hxf01@qq.com",@"pwd":login_aes_128_cbc_encrypt(@"Abc@1234")} success:^(id  _Nullable response) {
        NSLog(@"");
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

@end
