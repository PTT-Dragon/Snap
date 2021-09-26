//
//  CategoryContentCell.m
//  SFShop
//
//  Created by MasterFly on 2021/9/26.
//

#import "CategoryContentCell.h"

@interface CategoryContentCell ()
@property (nonatomic, readwrite, strong) UIImageView *iconImageView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@end

@implementation CategoryContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadsubviews];
        [self layout];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.iconImageView.mas_width).multipliedBy(1.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(KScale(4));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(KScale(30));
    }];
}

- (void)setModel:(CategoryModel *)model {
    _model = model;
    self.titleLabel.text = _model.inner.catgName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.inner.imgUrl)]];
}

#pragma mark - Getter
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.layer.borderColor = [UIColor jk_colorWithHexString:@"#CCCCCC"].CGColor;
        _iconImageView.layer.borderWidth = 0.5;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#262626"];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

@end
