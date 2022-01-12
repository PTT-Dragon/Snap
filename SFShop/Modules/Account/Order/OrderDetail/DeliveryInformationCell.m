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

@end

@implementation DeliveryInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(OrderDetailModel *)model
{
    DeliveryInfoModel *infoModel = model.deliverys.firstObject;
    _contentLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"PACKAGE_CODE"),infoModel.logisticsId];
    _infoLabel.text = [NSString stringWithFormat:@"%@\n%@",infoModel.warehouseName,infoModel.deliveryDate];
}
@end
