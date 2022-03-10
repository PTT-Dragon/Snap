//
//  CashOutDetailCell.m
//  SFShop
//
//  Created by 游挺 on 2022/3/10.
//

#import "CashOutDetailCell.h"

@interface CashOutDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CashOutDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setDic:(NSDictionary *)dic
{
    _titleLabel.text = dic[@"title"];
    _contentLabel.text = dic[@"content"];
}
@end
