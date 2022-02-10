//
//  CategoryRankNoItemsView.m
//  SFShop
//
//  Created by MasterFly on 2021/12/4.
//

#import "CategoryRankNoItemsView.h"

@interface CategoryRankNoItemsView ()
@property (nonatomic, readwrite, strong) UIImageView *iconView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@end
@implementation CategoryRankNoItemsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self composeSubviews];
    }
    return self;
}

- (void)loadSubviews {
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
}

- (void)composeSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-16);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
}

#pragma mark - Get and Set
- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"rank_no_goods"];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kLocalizedString(@"No_product_tip");
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = kFontRegular(14);
    }
    return _titleLabel;
}

@end
