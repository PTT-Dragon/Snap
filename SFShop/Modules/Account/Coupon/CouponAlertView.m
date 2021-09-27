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

@end

@implementation CouponAlertView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
}
- (IBAction)shoppingAction:(UIButton *)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
