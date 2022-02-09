//
//  CouponAlertView.m
//  SFShop
//
//  Created by 游挺 on 2021/9/27.
//

#import "CouponAlertView.h"

@interface CouponAlertView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation CouponAlertView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _contentLabel.text = kLocalizedString(@"COLLECT_COUPON_SUCCESS");
    [_btn setTitle:kLocalizedString(@"Go_Shopping") forState:0];
}
- (IBAction)shoppingAction:(UIButton *)sender {
    [[baseTool getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(aaa) withObject:nil afterDelay:0.1];
    [self removeFromSuperview];
}
- (void)aaa
{
AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
[appDelegate.tabVC setSelectedIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
