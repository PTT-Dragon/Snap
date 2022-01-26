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
    if ([dic.allKeys.firstObject rangeOfString:[NSString stringWithFormat:@"%@:",kLocalizedString(@"Total")]].location != NSNotFound) {
        _titleLabel.font = CHINESE_BOLD(15);
        _contentLabel.font = CHINESE_BOLD(15);
        _contentLabel.textColor = RGBColorFrom16(0xff1659);
    }else{
        _titleLabel.font = CHINESE_SYSTEM(14);
        _contentLabel.font = CHINESE_SYSTEM(14);
        
        _contentLabel.textColor = [UIColor blackColor];
    }
}
@end
