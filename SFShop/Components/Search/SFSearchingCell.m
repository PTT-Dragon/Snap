//
//  SFSearchingCell.m
//  SFShop
//
//  Created by MasterFly on 2021/12/4.
//

#import "SFSearchingCell.h"

@interface SFSearchingCell ()
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@end

@implementation SFSearchingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadsubviews];
        [self composesubviews];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)composesubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
}

#pragma mark - Get and Set
- (void)setModel:(SFSearchingModel *)model {
    _model = model;
    _titleLabel.text = model.text;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.text];
    NSRange range = [model.text rangeOfString:model.qStr];
    if (range.location != NSNotFound) {
        [att addAttributes:@{NSForegroundColorAttributeName:[UIColor jk_colorWithHexString:@"#FF1659"]} range:range];
    }
    _titleLabel.attributedText = att;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontRegular(16);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
