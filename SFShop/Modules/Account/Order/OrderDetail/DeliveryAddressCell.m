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

@end

@implementation DeliveryAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(OrderDetailModel *)model
{
    _contentLabel.text = model.deliveryAddress.contactAddress;
    _emailLabel.text = [NSString stringWithFormat:@"  %@",model.deliveryAddress.contactEmail];
}
@end
