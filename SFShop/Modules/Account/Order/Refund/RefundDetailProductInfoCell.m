//
//  RefundDetailProductInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailProductInfoCell.h"

@interface RefundDetailProductInfoCell ()
@property (weak, nonatomic) IBOutlet UITextView *instructionsView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@end

@implementation RefundDetailProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    _amountLabel.text = [NSString stringWithFormat:@"RP %@",model.refundCharge];
    _reasonLabel.text = model.orderReason;
    _typeLabel.text = [model.eventId isEqualToString:@"2"] ? @"Return": [model.eventId isEqualToString:@"3"] ? @"Refund": @"Exchange";
    _instructionsView.text = model.questionDesc;
}
@end
