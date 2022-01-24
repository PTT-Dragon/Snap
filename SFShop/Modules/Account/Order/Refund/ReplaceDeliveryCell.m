//
//  ReplaceDeliveryCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/24.
//

#import "ReplaceDeliveryCell.h"

@interface ReplaceDeliveryCell ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,assign) NSInteger row;

@end

@implementation ReplaceDeliveryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(NSDictionary *)dic row:(NSInteger)row
{
    _infoDic = dic;
    _row = row;
    _field1.text = dic[@"text1"];
    _field2.text = dic[@"text2"];
    _titleLabel.text = [NSString stringWithFormat:@"%@%ld",kLocalizedString(@"PACKAGE"),row+1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
