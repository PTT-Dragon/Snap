//
//  OrderPayInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "OrderPayInfoCell.h"

@interface OrderPayInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation OrderPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(NSDictionary *)dic
{
    _titleLabel.text = dic.allKeys.firstObject;
    _contentLabel.text = dic.allValues.firstObject;
}
@end
