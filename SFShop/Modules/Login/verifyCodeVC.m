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
    if (_type == LoginType_Code) {
        [self login];
    }
}
- (void)login
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.login parameters:@{@"account":_account,@"code":login_aes_128_cbc_encrypt(_codeView.code)} success:^(id  _Nullable response) {
        NSError *error = nil;
        [[FMDBManager sharedInstance] deleteUserData];
        UserModel *model = [[UserModel alloc] initWithDictionary:response error:&error];
        // TODO: 此处注意跟上边接口请求参数的account保持一致，不能直接使用userModel中的account字段（脱敏）
        [[FMDBManager sharedInstance] insertUser:model ofAccount:@"hxf01@qq.com"];
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}


@end
