//
//  CategoryRankFilterItem.m
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import "CategoryRankFilterItem.h"

@interface CategoryRankFilterItem ()

@property (nonatomic, readwrite, strong) UILabel *titleLabel;

@end

@implementation CategoryRankFilterItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self layout];
    }
    return self;
}

- (void)loadSubviews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Getter
- (void)setModel:(CategoryRankFilterModel *)model {
    _model = model;
    self.titleLabel.text = model.name;
    if (model.isSelected) {
        self.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        self.titleLabel.layer.borderColor = [UIColor jk_colorWithHexString:@"#FF1659"].CGColor;
    } else {
        self.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        self.titleLabel.layer.borderWidth = 1;
        self.titleLabel.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}
@end
