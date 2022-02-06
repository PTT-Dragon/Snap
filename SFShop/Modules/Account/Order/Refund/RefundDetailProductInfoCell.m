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
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation RefundDetailProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label1.text = kLocalizedString(@"SERVICE_TYPE");
    _label3.text = kLocalizedString(@"SERVICE_REASON");
    _label2.text = kLocalizedString(@"REFUND_AMOUNT");
    _label4.text = kLocalizedString(@"INSTRUCTIONS");
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    self.label.text = kLocalizedString(@"REFUND_AMOUNT");//[model.eventId isEqualToString:@"3"] ? kLocalizedString(@"REFUND_AMOUNT"): @"";
    _amountLabel.text = [model.refundCharge currency];// [model.eventId isEqualToString:@"3"] ? [model.refundCharge currency] : @"";
    _reasonLabel.text = model.orderReason;
    _typeLabel.text = [model.eventId isEqualToString:@"2"] ? kLocalizedString(@"Return"): [model.eventId isEqualToString:@"3"] ? kLocalizedString(@"Refund"): kLocalizedString(@"EXCHANGE");
    _instructionsView.text = model.questionDesc;
}
@end
