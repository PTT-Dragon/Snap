//
//  DistributorInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorInfoCell.h"
#import "CommissionViewController.h"

@interface DistributorInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *content1Label;
@property (weak, nonatomic) IBOutlet UILabel *content2Label;
@property (weak, nonatomic) IBOutlet UILabel *content3Label;

@end

@implementation DistributorInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(DistributionSettlementDtoModel *)model
{
    _model = model;
    
}
- (void)setContent:(DistributionSettlementDtoModel *)model type:(NSInteger)type
{
    _model = model;
    _titleLabel.text = type == 2 ? @"Commission": @"Sales Performance";
    _label1.text = type == 2 ? @"Balance:": @"";
    _label2.text = type == 2 ? @"Receivable:": @"";
    _label3.text = type == 2 ? @"Total:": @"";
    _content1Label.text = type == 2 ? [NSString stringWithFormat:@"RP %@",model.balanceCommission]: @"";
    _content2Label.text = type == 2 ? [NSString stringWithFormat:@"RP %@",model.balanceCommission]: @"";
    _content3Label.text = type == 2 ? [NSString stringWithFormat:@"RP %@",model.balanceCommission]: @"";
}
- (IBAction)detailAction:(id)sender {
    CommissionViewController *vc = [[CommissionViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
