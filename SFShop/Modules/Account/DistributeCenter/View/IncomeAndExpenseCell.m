//
//  IncomeAndExpenseCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import "IncomeAndExpenseCell.h"
#import "NSDate+Helper.h"
#import "NSString+Fee.h"


@interface IncomeAndExpenseCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation IncomeAndExpenseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(IncomeOrWithdrawListModel *)model
{
    _model = model;
    _nameLabel.text = model.commissionOperType;
    _timeLabel.text = [[NSDate dateFromString:model.createdDate] dayMonthYearHHMM];
    _amountLabel.text = [model.charge currency];
    _infoLabel.text = [NSString stringWithFormat:@"%@:\n%@",kLocalizedString(@"RELATION"),model.relaSn];
    
}
@end
