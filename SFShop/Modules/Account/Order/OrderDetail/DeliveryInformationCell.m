//
//  DeliveryInformationCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "DeliveryInformationCell.h"

@interface DeliveryInformationCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation DeliveryInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(OrderDetailModel *)model
{
    _contentLabel.text = model.billAddress.contactAddress;
}
@end
