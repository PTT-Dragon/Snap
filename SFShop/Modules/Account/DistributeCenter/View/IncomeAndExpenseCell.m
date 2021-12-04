//
//  IncomeAndExpenseCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import "IncomeAndExpenseCell.h"

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
    _timeLabel.text = model.createdDate;
    _amountLabel.text = [NSString stringWithFormat:@"RP %@",model.charge];
    _infoLabel.text = [NSString stringWithFormat:@"Relation:\n%@",model.relaSn];
    
}
@end
