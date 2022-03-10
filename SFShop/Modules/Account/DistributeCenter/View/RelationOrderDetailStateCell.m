//
//  RelationOrderDetailStateCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "RelationOrderDetailStateCell.h"
#import "NSString+Fee.h"

@interface RelationOrderDetailStateCell ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RelationOrderDetailStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.text = kLocalizedString(@"ESTIMATED_COMMISSION");
}
- (void)setModel:(RelationOrderDetailModel *)model
{
    //0x00B256
    _model = model;
    _stateLabel.text = [model.settState isEqualToString:@"Settled"] ? @"S": @"P";
    _stateLabel.layer.borderColor = [model.settState isEqualToString:@"Settled"] ? RGBColorFrom16(0xff1659).CGColor: RGBColorFrom16(0xff1659).CGColor;
    _stateLabel.layer.borderWidth = 2;
    _contentLabel.text = [model.settState isEqualToString:@"Settled"] ? @"Settled": @"Pending";
    _contentLabel.textColor = [model.settState isEqualToString:@"Settled"] ? RGBColorFrom16(0xff1659): RGBColorFrom16(0xff1659);
    _timeLabel.text = [model.settState isEqualToString:@"Settled"] ? model.stateDate: @"--";
    _amountLabel.text = [model.kolCommission currency];
}
@end
