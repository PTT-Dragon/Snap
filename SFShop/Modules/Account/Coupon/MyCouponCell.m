//
//  MyCouponCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponCell.h"

@interface MyCouponCell ()
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(CouponModel *)model
{
    _nameLabel.text = model.couponName;
    _timeLabel.text = model.expDate;
    
}
@end
