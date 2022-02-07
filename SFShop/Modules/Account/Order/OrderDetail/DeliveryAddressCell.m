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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toEmail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;

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
    _phoneLabel.textColor = [UIColor blackColor];
    _contentLabel.textColor = [UIColor blackColor];
    _nameTop.constant = 18;
    _toBottom.priority = 750;
    _toEmail.priority = 250;
    _titleLabel.text = kLocalizedString(@"RETURN_ADDRESS");
    _emailLabel.hidden = YES;
    _nameLabel.text = model.returnAddress.contactName;
    _phoneLabel.text = model.returnAddress.contactNbr;
    _contentLabel.text = model.returnAddress.fullAddress;
    _emailLabel.text = [NSString stringWithFormat:@"  %@",model.returnAddress.contactEmail];
}
@end
