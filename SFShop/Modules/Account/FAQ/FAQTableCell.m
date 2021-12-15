//
//  FAQTableCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "FAQTableCell.h"


@interface FAQTableCell ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation FAQTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor blackColor];
    _label.numberOfLines = 0;
    _label.font = CHINESE_SYSTEM(12);
    [self.contentView addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(22);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-60);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBColorFrom16(0xf0f0f0);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-scroll"]];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}
- (void)setContent:(NSString *)content highlightText:(NSString *)highlightText
{
    _label.text = content;
    _label.attributedText = [NSMutableString stringWithHighLightSubstring:content substring:highlightText color:RGBColorFrom16(0xFF1659)];
}
@end
