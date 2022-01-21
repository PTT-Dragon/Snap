//
//  MyCouponCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponCell.h"
#import "UseCouponViewController.h"
#import "NSString+Fee.h"

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
    if ([model.discountMethod isEqualToString:@"DISC"]) {
        _nameLabel.text = [NSString stringWithFormat:@"Discount %@ Min.spend %@",[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency],[[NSString stringWithFormat:@"%@f",model.thAmount] currency]];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"Discount %@ Without limit",[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency]];
    }
    if (model.getOffsetExp != nil) {
        _timeLabel.text = [NSString stringWithFormat:@"Valid within %@ days",model.getOffsetExp];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.effDateStr,model.expDateStr];
    }
    _statuLabel.text = [model.userCouponState isEqualToString:@"C"] ? @"EXPIRED": [model.userCouponState isEqualToString:@"A"] ? @"USE NOW": @"USED";
    if (model.userCouponState) {
        _statuLabel.textColor = ![model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFFA6C0): RGBColorFrom16(0xFF1659);
        _discountView.backgroundColor = ![model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFFA6C0): RGBColorFrom16(0xFF1659);
    }else{
        _statuLabel.textColor = RGBColorFrom16(0xFF1659);
        _discountView.backgroundColor = RGBColorFrom16(0xFF1659);
    }
    
}
- (void)useCouponAction
{
    UseCouponViewController *vc = [[UseCouponViewController alloc] init];
    vc.couponModel = _model;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
