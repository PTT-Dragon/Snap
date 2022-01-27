//
//  MyCouponCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponCell.h"
#import "UseCouponViewController.h"
#import "NSString+Fee.h"
#import "NSDate+Helper.h"

@interface MyCouponCell ()
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (nonatomic,weak) CouponModel *model;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useCouponAction)];
    [_statuLabel addGestureRecognizer:tap];
    _label1.text = kLocalizedString(@"DISCOUNT");
    _label2.text = kLocalizedString(@"EXPIRY_DATE");
}
- (void)setContent:(CouponModel *)model
{
    _model = model;
    if ([model.discountMethod isEqualToString:@"DISC"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ %.2f%% Min.spend %.2f",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0f",model.discountAmount] currencyFloat],[[NSString stringWithFormat:@"%@",model.thAmount] currencyFloat]];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@ Without limit",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency]];
    }
    if (model.getOffsetExp != nil) {
//        _timeLabel.text = [NSString stringWithFormat:@"Valid within %@ days",[[NSDate dateFromString:model.getOffsetExp] dayMonthYear]];
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.userCouponEffDate] dayMonthYear],[[NSDate dateFromString:model.userCouponExpDate] dayMonthYear]];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.effDate] dayMonthYear],[[NSDate dateFromString:model.expDate] dayMonthYear]];
    }
    _statuLabel.text = [model.userCouponState isEqualToString:@"C"] ? @"EXPIRED": [model.userCouponState isEqualToString:@"A"] ? kLocalizedString(@"USE_NOW"): kLocalizedString(@"USED");
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
