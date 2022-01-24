//
//  RefundDetailMethodCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailMethodCell.h"

@interface RefundDetailMethodCell ()
@property (weak, nonatomic) IBOutlet UILabel *methodLabel;

@end

@implementation RefundDetailMethodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    NSString *str = ([model.refund.paymentMode isEqualToString:@"A"] && model.refund) ? model.refund.paymentMethodName: @"Bank Transfer";
    _methodLabel.text = [NSString stringWithFormat:@"Refund to %@",str];
}
@end
