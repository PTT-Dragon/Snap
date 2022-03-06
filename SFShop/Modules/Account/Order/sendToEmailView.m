//
//  sendToEmailView.m
//  SFShop
//
//  Created by 游挺 on 2022/3/6.
//

#import "sendToEmailView.h"

@interface sendToEmailView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation sendToEmailView
static BOOL _accountSuccess = NO;


- (void)awakeFromNib
{
    [super awakeFromNib];
    _titleLabel.text = kLocalizedString(@"SEND_TO_EMAIL");
    [_yesBtn setTitle:kLocalizedString(@"YES") forState:0];
    [_noBtn setTitle:kLocalizedString(@"NO") forState:0];
    _noBtn.layer.borderWidth = 1;
    _noBtn.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
    _tipLabel.hidden = YES;
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    _field.placeholder = kLocalizedString(@"FILL_EMAIL");
    if (![model.userRes.email isEqualToString:@""]) {
        _field.text = model.userRes.email;
        _accountSuccess = YES;
    }else{
        
    }
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [_bgView addGestureRecognizer:tap];
    self.field.delegate = self;
    [self.field addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changedTextField:(UITextField *)textField
{
    _accountSuccess = [textField.text emailTextCheck];
    if (!_accountSuccess) {
        _tipLabel.hidden = NO;
        _tipLabel.text = kLocalizedString(@"INCORRECT_EMAIL");
    }else{
        _tipLabel.hidden = YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if ([textField.text isEqualToString:@""]) {
        _tipLabel.hidden = NO;
        _tipLabel.text = kLocalizedString(@"Please_enter_your_email");
    }else if ([textField.text isEqualToString:model.userRes.email]){
        textField.text = @"";
    }
}
- (void)removeSelf
{
    [self removeFromSuperview];
}
- (IBAction)noAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)yesAction:(id)sender {
    if (_accountSuccess) {
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        NSString *email = @"";
        if (![_field.text isEqualToString:model.userRes.email]) {
            email = _field.text;
        }
        [SFNetworkManager post:SFNet.h5.sendEmail parameters:@{@"email":email,@"orderId":_orderId} success:^(id  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"SEND_TO_EMAIL_SUCCESSFULLY")];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        }];
        [self removeFromSuperview];
    }
}
@end
