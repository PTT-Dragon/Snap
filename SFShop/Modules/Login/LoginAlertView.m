//
//  LoginAlertView.m
//  SFShop
//
//  Created by 游挺 on 2021/9/25.
//

#import "LoginAlertView.h"

@interface LoginAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation LoginAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _cancelBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _cancelBtn.layer.borderWidth = 1;
}

- (IBAction)loginAction:(id)sender {
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

@end
