//
//  RefundOrReturnExplainCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/18.
//

#import "RefundOrReturnExplainCell.h"

@interface RefundOrReturnExplainCell ()
@property (nonatomic,strong) UILabel *chargeLabel;
@property (nonatomic,strong) UITextView *InstructionsView;
@end

@implementation RefundOrReturnExplainCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)layoutSubviews
{
    if (self.type == RETURNTYPE || self.type == REFUNDTYPE) {
        UILabel *label = [[UILabel alloc] init];
        label.text = kLocalizedString(@"REFUND_AMOUNT");
        label.font = CHINESE_SYSTEM(13);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(18);
            make.top.mas_equalTo(self.contentView.mas_top).offset(19);
        }];
        [self.contentView addSubview:self.chargeLabel];
        [self.chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-19);
            make.centerY.equalTo(label);
        }];
    }
    [self.contentView addSubview:self.InstructionsView];
    [self.InstructionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-18);
        make.width.mas_equalTo(AdaptedWidth(180));
        make.height.mas_equalTo(30);
    }];
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = kLocalizedString(@"INSTRUCTIONS");
    label2.font = CHINESE_SYSTEM(13);
    [self.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(18);
        make.centerY.equalTo(self.InstructionsView);
    }];
}
- (void)setChargeModel:(RefundChargeModel *)chargeModel
{
    _chargeLabel = chargeModel;
    self.
}
- (UILabel *)chargeLabel
{
    if (!_chargeLabel) {
        _chargeLabel = [[UILabel alloc] init];
        _chargeLabel.font = CHINESE_SYSTEM(13);
    }
    return _chargeLabel;
}
- (UITextView *)InstructionsView
{
    if (!_InstructionsView) {
        _InstructionsView = [[UITextView alloc] init];
        _InstructionsView.backgroundColor = RGBColorFrom16(0xf5f5f5);
        _InstructionsView.font = CHINESE_SYSTEM(12);
    }
    return _InstructionsView;
}
@end
