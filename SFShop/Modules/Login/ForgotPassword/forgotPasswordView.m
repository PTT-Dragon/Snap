//
//  forgotPasswordView.m
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import "forgotPasswordView.h"
#import "resetPasswordViewController.h"

@interface forgotPasswordView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

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
- (IBAction)SMSAction:(id)sender {
    resetPasswordViewController *vc = [[resetPasswordViewController alloc] init];
    vc.type = 1;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)eamilAction:(id)sender {
    resetPasswordViewController *vc = [[resetPasswordViewController alloc] init];
    vc.type = 2;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)delAction:(id)sender {
    [self removeFromSuperview];
}

@end
