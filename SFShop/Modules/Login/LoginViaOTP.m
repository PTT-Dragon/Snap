//
//  LoginViaOTP.m
//  SFShop
//
//  Created by 游挺 on 2021/9/25.
//

#import "LoginViaOTP.h"
#import "verifyCodeVC.h"

@interface LoginViaOTP ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation LoginViaOTP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)sendAction:(id)sender {
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    vc.account = self.field.text;
    [self.navigationController pushViewController:vc animated:YES];
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
