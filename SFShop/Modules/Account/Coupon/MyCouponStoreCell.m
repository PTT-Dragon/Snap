//
//  MyCouponStoreCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponStoreCell.h"

@interface MyCouponStoreCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MyCouponStoreCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = RGBColorFrom16(0xf5f5f5);
    self.contentView.backgroundColor = RGBColorFrom16(0xf5f5f5);
}
- (void)setContent:(CouponModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogo)] placeholderImage:[UIImage imageNamed:@"get-coupons"]];
    _nameLabel.text = model.storeName ? model.storeName: kLocalizedString(@"SFshop_Voucher");
}

@end
