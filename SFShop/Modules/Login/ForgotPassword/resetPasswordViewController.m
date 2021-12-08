//
//  resetPasswordViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "resetPasswordViewController.h"
#import "verifyCodeVC.h"

@interface resetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation resetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_type == 2) {
        _label.text = @"A verification code will be sent to your email address. Please enter your registered email.";
        _field.placeholder = @"Email";
    }
}
- (IBAction)sendAction:(UIButton *)sender {
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.check parameters:@{@"account":_field.text} success:^(id  _Nullable response) {
        if ([response[@"isExisting"] isEqualToString:@"1"]) {
            //已注册
            verifyCodeVC *vc = [[verifyCodeVC alloc] init];
            vc.account = weakself.field.text;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}


@end
