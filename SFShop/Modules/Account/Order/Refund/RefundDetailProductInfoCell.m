//
//  RefundDetailProductInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailProductInfoCell.h"
#import "NSString+Fee.h"

@interface RefundDetailProductInfoCell ()
@property (weak, nonatomic) IBOutlet UITextView *instructionsView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RefundDetailProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    self.label.text = [model.eventId isEqualToString:@"3"] ? kLocalizedString(@"REFUND_AMOUNT"): @"";
    _amountLabel.text = [model.eventId isEqualToString:@"3"] ? [model.refundCharge currency] : @"";
    _reasonLabel.text = model.orderReason;
    _typeLabel.text = [model.eventId isEqualToString:@"2"] ? @"Return": [model.eventId isEqualToString:@"3"] ? @"Refund": @"Exchange";
    _instructionsView.text = model.questionDesc;
}
@end
