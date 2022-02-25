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
    _titleLabel.text = kLocalizedString(@"DELIVERY_INFORMATION");
}
- (void)setContent:(OrderDetailModel *)model
{
    DeliveryInfoModel *infoModel = model.deliverys.firstObject;
    _contentLabel.text = [NSString stringWithFormat:@"    %@%@",kLocalizedString(@"PACKAGE_CODE"),infoModel.shippingNbr?infoModel.shippingNbr:@""];
    NSString *state = ([model.deliveryState isEqualToString:@"C"] || [model.deliveryState isEqualToString:@"A"]) ? @"WAREHOUSE_HAS_BEEN_DELIVERED": @"";
    self.logisticsName.text = infoModel.logisticsName;
    
    _infoLabel.text = [NSString stringWithFormat:@"%@\n%@",kLocalizedString(state),infoModel.deliveryDate];
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",kLocalizedString(state),infoModel.deliveryDate]];
//    [text addAttributes:@{NSForegroundColorAttributeName:[UIColor jk_colorWithHexString:@"#333333"]} range:NSMakeRange(0, kLocalizedString(state).length)];
//    [text addAttributes:@{NSForegroundColorAttributeName:[UIColor jk_colorWithHexString:@"#333333"]} range:NSMakeRange(text.length-infoModel.deliveryDate.length, infoModel.deliveryDate.length)];
//    _infoLabel.attributedText = text;
}
@end
