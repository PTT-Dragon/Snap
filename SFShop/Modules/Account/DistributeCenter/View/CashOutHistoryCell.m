//
//  CashOutHistoryCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "CashOutHistoryCell.h"
#import "NSString+Fee.h"
#import "NSDate+Helper.h"

@interface CashOutHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end

@implementation CashOutHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(CashOutHistoryListModel *)model
{
    _model = model;
    _nameLabel.text = model.reqSn;
    _amountLabel.text = [model.withdrawalAmount currency];
    _dateLabel.text = [[NSDate dateFromString:model.stateDate] dayMonthYearHHMM];
    _statuLabel.text = model.state;
}
@end
