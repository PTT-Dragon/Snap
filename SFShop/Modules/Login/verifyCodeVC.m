//
//  verifyCodeVC.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "verifyCodeVC.h"
#import "HWTFCodeBView.h"
#import "AES128Util.h"

@interface verifyCodeVC ()<HWTFCodeBViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet HWTFCodeBView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@end

@implementation verifyCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _codeView.delegate = self;
    [SFNetworkManager post:SFNet.account.getCode parameters:@{@"account":_account,@"userType":@"Terminal"} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
//完成输入验证码
- (void)codeFinish
{
    //验证验证码
    [SFNetworkManager post:SFNet.account.codeCheck parameters:@{@"account":_account,@"userType":@"Terminal",@"code":_codeView.code} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}


@end
