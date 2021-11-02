//
//  DistributorInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorInfoCell.h"

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
- (IBAction)detailAction:(id)sender {
}
@end
