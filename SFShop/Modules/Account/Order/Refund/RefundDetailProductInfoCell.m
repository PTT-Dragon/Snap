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
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label3Top;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *approvalChargeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label5Top;

@end

@implementation RefundDetailProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label1.text = kLocalizedString(@"SERVICE_TYPE");
    _label3.text = kLocalizedString(@"SERVICE_REASON");
    _label2.text = kLocalizedString(@"REFUND_AMOUNT");
    _label5.text = kLocalizedString(@"FINAL_REFUND_AMOUNT");
    _label4.text = [NSString stringWithFormat:@"%@:",kLocalizedString(@"INSTRUCTIONS")];
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    if ([model.eventId isEqualToString:@"4"]) {
        self.label5Top.constant = 1;
    }else{
        self.label3Top.constant = 32;
        self.label5.hidden = NO;
        self.approvalChargeLabel.hidden = NO;
    }
    self.approvalChargeLabel.text = !model.approvalCharge ? [@"0" currency]: [model.approvalCharge currency];
    self.label2.text = [model.eventId isEqualToString:@"4"] ? @"": kLocalizedString(@"REFUND_AMOUNT");
    _amountLabel.text = [model.eventId isEqualToString:@"4"] ? @"" : [model.refundCharge currency];
    _reasonLabel.text = model.orderReason;
    _typeLabel.text = [model.eventId isEqualToString:@"2"] ? kLocalizedString(@"RETURN"): ([model.eventId isEqualToString:@"3"] || [model.eventId isEqualToString:@"5"]) ? kLocalizedString(@"Refund"): kLocalizedString(@"EXCHANGE");
    _instructionsView.text = model.questionDesc;
}
@end
