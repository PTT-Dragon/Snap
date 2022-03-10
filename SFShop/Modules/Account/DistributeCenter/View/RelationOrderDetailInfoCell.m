//
//  RelationOrderDetailInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "RelationOrderDetailInfoCell.h"

@interface RelationOrderDetailInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation RelationOrderDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _titleLabel.text = [infoDic allKeys].firstObject;
    _contentLabel.text = [infoDic allValues].firstObject;
    if ([infoDic.allKeys.firstObject rangeOfString:[NSString stringWithFormat:@"%@:",kLocalizedString(@"Total")]].location != NSNotFound) {
        _titleLabel.font = CHINESE_BOLD(15);
        _contentLabel.font = CHINESE_BOLD(15);
        _contentLabel.textColor = RGBColorFrom16(0xff1659);
    }else if ([infoDic.allKeys.firstObject rangeOfString:[NSString stringWithFormat:@"%@",kLocalizedString(@"PROMOTION")]].location != NSNotFound){
        _titleLabel.font = CHINESE_SYSTEM(14);
        _contentLabel.font = CHINESE_BOLD(15);
        _contentLabel.textColor = RGBColorFrom16(0xff1659);
        _contentLabel.text = [NSString stringWithFormat:@"-%@",infoDic.allValues.firstObject];
    }else{
        _titleLabel.font = CHINESE_SYSTEM(14);
        _contentLabel.font = CHINESE_SYSTEM(14);
        _contentLabel.textColor = [UIColor blackColor];
    }
}

@end
