//
//  forgotPasswordView.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "forgotPasswordView.h"
#import "resetPasswordViewController.h"
#import "ChangePasswordViewController.h"


@interface forgotPasswordView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation forgotPasswordView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _smsBtn.layer.borderColor = RGBColorFrom16(0xc4c4c4).CGColor;
    _smsBtn.layer.borderWidth = 1;
    _emailBtn.layer.borderColor = RGBColorFrom16(0xc4c4c4).CGColor;
    _emailBtn.layer.borderWidth = 1;
    _smsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _emailBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_smsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 30)];
    [_smsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 50)];
    [_emailBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 30)];
    [_emailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 50)];
    
}
- (void)setType:(changePasswordType)type
{
    _type = type;
//    _titleLabel.text = _type == forgetType ? kLocalizedString(@"FORGOT_PWD"): kLocalizedString(@"CHANGE_PASS");
//    _contentLabel.text = _type == forgetType ? kLocalizedString(@"FORGOT_PWD_SELECT_MODAL_TITLE"): kLocalizedString(@"FORGOT_PWD_SELECT_MODAL_TITLE");
//    [_smsBtn setTitle:_type == forgetType ? kLocalizedString(@"RESET_WITH_SMS"): kLocalizedString(@"RESET_WITH_SMS") forState:0];
    _titleLabel.text = kLocalizedString(@"CHANGE_PASS");
    _contentLabel.text = kLocalizedString(@"FORGOT_PWD_SELECT_MODAL_TITLE");
    [_smsBtn setTitle:kLocalizedString(@"RESET_WITH_SMS") forState:0];
    [_emailBtn setTitle:kLocalizedString(@"RESET_WITH_EMAIL") forState:0];
    [_cancelBtn setTitle:kLocalizedString(@"CANCEL") forState:0];
}
- (IBAction)SMSAction:(id)sender {
//    if (_type == resetType) {
        resetPasswordViewController *vc = [[resetPasswordViewController alloc] init];
        vc.type = 1;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }
//    else if (_type == forgetType){
//        ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
//        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }
}
- (IBAction)eamilAction:(id)sender {
//    if (_type == resetType) {
        resetPasswordViewController *vc = [[resetPasswordViewController alloc] init];
        vc.type = 2;
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if (_type == forgetType){
//        ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
//        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }
}
- (IBAction)delAction:(id)sender {
    [self removeFromSuperview];
}

@end
