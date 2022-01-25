//
//  RefundOrReturnReasonCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/25.
//

#import "RefundOrReturnReasonCell.h"

@interface RefundOrReturnReasonCell ()

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@end

@implementation RefundOrReturnReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _reasonLabel.text = kLocalizedString(@"SERVICE_REASON");
}

- (IBAction)btnAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
