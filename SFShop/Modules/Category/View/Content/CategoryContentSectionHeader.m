//
//  CategoryContentSectionHeader.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "CategoryContentSectionHeader.h"

@implementation CategoryContentSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self  = [super initWithFrame:frame]) {
        [self loadsubviews];
        [self layout];
    }
    return self;
}

- (void)loadsubviews {
    [self addSubview:self.titleLabel];
}

- (void)layout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(KScale(19));
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end
