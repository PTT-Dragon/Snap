//
//  MyCouponCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponCell.h"
#import "UseCouponViewController.h"

@interface MyCouponCell ()
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (nonatomic,weak) CouponModel *model;

@end

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useCouponAction)];
    [_statuLabel addGestureRecognizer:tap];
}
- (void)setContent:(CouponModel *)model
{
    _model = model;
    _nameLabel.text = model.couponName;
    _timeLabel.text = model.expDate;
    _statuLabel.text = [model.userCouponState isEqualToString:@"C"] ? @"EXPIRED": [model.userCouponState isEqualToString:@"A"] ? @"USE NOW": @"USED";
    _statuLabel.textColor = [model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFF1659): RGBColorFrom16(0xFFA6C0);
    _discountView.backgroundColor = [model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFF1659): RGBColorFrom16(0xFFA6C0);
}
- (void)useCouponAction
{
    UseCouponViewController *vc = [[UseCouponViewController alloc] init];
    vc.couponModel = _model;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
