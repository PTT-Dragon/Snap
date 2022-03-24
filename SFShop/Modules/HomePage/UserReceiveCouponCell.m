//
//  UserReceiveCouponCell.m
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import "UserReceiveCouponCell.h"
#import "NSDate+Helper.h"

@interface UserReceiveCouponCell ()
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
//@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation UserReceiveCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label2.text = kLocalizedString(@"EXPIRY_DATE");
    self.contentView.layer.borderColor = RGBColorFrom16(0xe7e7e7).CGColor;
    self.contentView.layer.borderWidth = 1;
}
- (void)setModel:(CouponModel *)model
{
    _model = model;
    _nameLabel.text = model.couponName;
//    if ([model.discountMethod isEqualToString:@"DISC"]) {
//        _nameLabel.text = [NSString stringWithFormat:@"%@ %.2f%% Min.spend %.2f",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0f",model.discountAmount] currencyFloat],[[NSString stringWithFormat:@"%@",model.thAmount] currencyFloat]];
//    }else{
//        _nameLabel.text = [NSString stringWithFormat:@"%@ %@ Without limit",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0f",model.discountAmount] currency]];
//    }
    if (model.isGet) {
        _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.userCouponEffDate] dayMonthYear],[[NSDate dateFromString:model.userCouponExpDate] dayMonthYear]];
    }else{
        if (model.getOffsetExp) {
            _timeLabel.text = [NSString stringWithFormat:@"Valid within %@ days",model.getOffsetExp];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:model.effDate] dayMonthYear],[[NSDate dateFromString:model.expDate] dayMonthYear]];
        }
    }
    if ([model.userCouponState isEqualToString:@"C"]) {
        _statuLabel.text = kLocalizedString(@"EXPIRED");
    }else if ([model.userCouponState isEqualToString:@"B"]){
        _statuLabel.text = kLocalizedString(@"USED");
    }else if ([model.userCouponState isEqualToString:@"A"]){
        if (model.isGet) {
            _statuLabel.text = kLocalizedString(@"USE_NOW");
        }else{
            if (!model.isGet) {
                _statuLabel.text = kLocalizedString(@"USE_NOW");
            }else{
                _statuLabel.text = kLocalizedString(@"GET_NOW");
            }
        }
    }else if (!model.userCouponState){
        if (model.isGet) {
            _statuLabel.text = kLocalizedString(@"USE_NOW");
        }else{
            _statuLabel.text = kLocalizedString(@"GET_NOW");
        }
    }
//    if (model.isGet) {
//        _statuLabel.text = kLocalizedString(@"USE_NOW");
//    }else{
//        _statuLabel.text = !model.userCouponState ? kLocalizedString(@"USE_NOW"): [model.userCouponState isEqualToString:@"C"] ? kLocalizedString(@"EXPIRED"): [model.userCouponState isEqualToString:@"A"] ? kLocalizedString(@"USE_NOW"): kLocalizedString(@"USED");
//    }
    
    if (model.userCouponState) {
        _statuLabel.textColor = ![model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFFA6C0): RGBColorFrom16(0xFF1659);
        _discountView.backgroundColor = ![model.userCouponState isEqualToString:@"A"] ? RGBColorFrom16(0xFFA6C0): RGBColorFrom16(0xFF1659);
    }else{
        _statuLabel.textColor = RGBColorFrom16(0xFF1659);
        _discountView.backgroundColor = RGBColorFrom16(0xFF1659);
    }
}
@end
