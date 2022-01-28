//
//  DeliveryAddressCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "DeliveryAddressCell.h"

@interface DeliveryAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DeliveryAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.text = kLocalizedString(@"Delivery_address");
}
- (void)setContent:(OrderDetailModel *)model
{
    _nameLabel.text = model.deliveryAddress.contactName;
    _phoneLabel.text = model.deliveryAddress.contactNbr;
    _contentLabel.text = model.deliveryAddress.contactAddress;
    _emailLabel.text = [NSString stringWithFormat:@"  %@",model.deliveryAddress.contactEmail];
}
- (void)setRefundContent:(RefundDetailModel *)model
{
    _emailLabel.hidden = YES;
    _nameLabel.text = model.returnAddress.contactName;
    _phoneLabel.text = model.returnAddress.contactNbr;
    _contentLabel.text = model.returnAddress.fullAddress;
    _emailLabel.text = [NSString stringWithFormat:@"  %@",model.returnAddress.contactEmail];
}
@end
