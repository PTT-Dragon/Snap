//
//  RefundDetailMethodCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailMethodCell.h"

@interface RefundDetailMethodCell ()
@property (weak, nonatomic) IBOutlet UILabel *methodLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RefundDetailMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    _label.text = kLocalizedString(@"REFUND_METHOD");
    NSString *str = ([model.refund.paymentMode isEqualToString:@"A"] && model.refund) ? model.refund.paymentMethodName: kLocalizedString(@"BANK_TRANSFER");
    _methodLabel.text = str;//[model.eventId isEqualToString:@"3"] ? @"": [NSString stringWithFormat:@"Refund to %@",str];
}
@end
