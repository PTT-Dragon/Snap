//
//  DeliveryInformationCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "DeliveryInformationCell.h"

@interface DeliveryInformationCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsName;

@end

@implementation DeliveryInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.text = kLocalizedString(@"ORDER_INFORMATION");
}
- (void)setContent:(OrderDetailModel *)model
{
    DeliveryInfoModel *infoModel = model.deliverys.firstObject;
    _contentLabel.text = [NSString stringWithFormat:@"    %@%@",kLocalizedString(@"PACKAGE_CODE"),infoModel.logisticsId];
    NSString *state = [model.deliveryState isEqualToString:@"C"] ? @"WAREHOUSE_HAS_BEEN_DELIVERED": @"";
    _infoLabel.text = [NSString stringWithFormat:@"%@\n%@",kLocalizedString(state),infoModel.deliveryDate];
    self.logisticsName.text = infoModel.logisticsName;
}
@end
