//
//  CategoryRankCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/12.
//

#import "CategoryRankCell.h"

@interface CategoryRankCell ()

@property (nonatomic, readwrite, strong) UIImageView *iconImageView;
@property (nonatomic, readwrite, strong) UILabel *promoTypeLabel;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *discountLabel;
@property (nonatomic, readwrite, strong) UILabel *originPriceLabel;
@property (nonatomic, readwrite, strong) UIImageView *gradeImageView;
@property (nonatomic, readwrite, strong) UILabel *gradeLevelLabel;
@property (nonatomic, readwrite, strong) UILabel *gradeNumberLabel;
@end
@implementation CategoryRankCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self layoutCollection];
    }
    return self;
}

- (void)loadSubviews {
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor jk_colorWithHexString:@"#CCCCCC"].CGColor;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.promoTypeLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.discountLabel];
    [self.contentView addSubview:self.originPriceLabel];
    [self.contentView addSubview:self.gradeImageView];
    [self.contentView addSubview:self.gradeLevelLabel];
    [self.contentView addSubview:self.gradeNumberLabel];
}

- (void)layoutTableView {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(0);
        make.width.mas_equalTo(KScale(160));
        make.height.mas_equalTo(KScale(160));
    }];
    
    [self.promoTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(KScale(16));
        make.top.mas_equalTo(KScale(13));
        make.height.mas_equalTo(KScale(14));//14,先注释
        make.width.mas_equalTo(78);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promoTypeLabel);
        make.top.equalTo(self.promoTypeLabel.mas_bottom).offset(KScale(12));
        make.right.mas_equalTo(KScale(-12));
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promoTypeLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(KScale(16));
        make.height.mas_equalTo(KScale(14));
        make.right.mas_equalTo(KScale(-12));
    }];
    
    [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promoTypeLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(KScale(4));
        make.height.mas_equalTo(KScale(14));
        make.width.mas_equalTo(KScale(30));
    }];
    
    [self.originPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountLabel.mas_right).offset(KScale(8));
        make.right.mas_equalTo(KScale(-12));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(KScale(4));
        make.height.mas_equalTo(KScale(12));
    }];
    
    [self.gradeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promoTypeLabel);
        make.top.equalTo(self.originPriceLabel.mas_bottom).offset(KScale(12));
        make.height.mas_equalTo(KScale(12));
        make.width.mas_equalTo(KScale(12));
    }];
    
    [self.gradeLevelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradeImageView.mas_right).offset(KScale(2));
        make.top.equalTo(self.originPriceLabel.mas_bottom).offset(KScale(12));
        make.height.mas_equalTo(KScale(12));
    }];
    
    [self.gradeNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradeLevelLabel.mas_right).offset(KScale(8));
        make.top.equalTo(self.originPriceLabel.mas_bottom).offset(KScale(12));
        make.height.mas_equalTo(KScale(12));
    }];
}

- (void)layoutCollection {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(KScale(166));
    }];
    
    [self.promoTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(12));
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(KScale(16));
//        make.height.mas_equalTo(KScale(14));//14,先注释
        make.top.equalTo(self.iconImageView.mas_bottom).offset(KScale(0));
        make.height.mas_equalTo(KScale(0));//14,先注释
        make.right.mas_equalTo(KScale(-12));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(12));
        make.top.equalTo(self.promoTypeLabel.mas_bottom).offset(KScale(12));
        make.right.mas_equalTo(KScale(-12));
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(12));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(KScale(16));
        make.height.mas_equalTo(KScale(14));
        make.right.mas_equalTo(KScale(-12));
    }];
    
    [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(12));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(KScale(4));
        make.height.mas_equalTo(KScale(14));
        make.width.mas_equalTo(KScale(30));
    }];
    
    [self.originPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountLabel.mas_right).offset(KScale(8));
        make.right.mas_equalTo(KScale(-12));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(KScale(4));
        make.height.mas_equalTo(KScale(12));
    }];
    
    [self.gradeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(12));
        make.top.equalTo(self.originPriceLabel.mas_bottom).offset(KScale(12));
        make.height.mas_equalTo(KScale(12));
        make.width.mas_equalTo(KScale(12));
    }];
    
    [self.gradeLevelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradeImageView.mas_right).offset(KScale(2));
        make.top.equalTo(self.originPriceLabel.mas_bottom).offset(KScale(12));
        make.height.mas_equalTo(KScale(12));
    }];
    
    [self.gradeNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradeLevelLabel.mas_right).offset(KScale(8));
        make.top.equalTo(self.originPriceLabel.mas_bottom).offset(KScale(12));
        make.height.mas_equalTo(KScale(12));
    }];

}

#pragma mark - Getter
- (void)setShowType:(NSInteger)showType {
    _showType = showType;
    switch (_showType) {
        case 1:
            [self layoutTableView];
            break;
        case 0:
        default:
            [self layoutCollection];
            break;
    }
}

- (void)setModel:(CategoryRankPageInfoListModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.imgUrl)]];
    self.titleLabel.text = _model.offerName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@",_model.currencySymbol,[[NSString stringWithFormat:@"%ld",_model.salesPrice] thousandthFormat]] ;
    self.gradeLevelLabel.text = _model.evaluationAvg;
    self.gradeNumberLabel.text = [NSString stringWithFormat:@"(%ld)",_model.evaluationCnt];
    self.discountLabel.text = [NSString stringWithFormat:@"%@%%",_model.discountPercent];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@ %@",_model.currencySymbol,[[NSString stringWithFormat:@"%ld",_model.marketPrice] thousandthFormat]] attributes:
    @{NSFontAttributeName:[UIFont systemFontOfSize:10],
      NSForegroundColorAttributeName:[UIColor jk_colorWithHexString:@"#7B7B7B"],
      NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
      NSStrikethroughColorAttributeName:[UIColor jk_colorWithHexString:@"#CCCCCC"]}];
    self.originPriceLabel.attributedText = attrStr;
}

- (UIImageView *)iconImageView  {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"";
        _priceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

- (UILabel *)discountLabel {
    if (_discountLabel == nil) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.text = @"";
        _discountLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        _discountLabel.font = [UIFont systemFontOfSize:8];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.backgroundColor = [UIColor jk_colorWithHexString:@"#FF1659"];
    }
    return _discountLabel;
}

- (UILabel *)originPriceLabel {
    if (_originPriceLabel == nil) {
        _originPriceLabel = [[UILabel alloc] init];
        _originPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _originPriceLabel.font = [UIFont systemFontOfSize:10];
        _originPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _originPriceLabel;
}

- (UILabel *)gradeLevelLabel {
    if (_gradeLevelLabel == nil) {
        _gradeLevelLabel = [[UILabel alloc] init];
        _gradeLevelLabel.text = @"";
        _gradeLevelLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _gradeLevelLabel.font = [UIFont systemFontOfSize:10];
        _gradeLevelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _gradeLevelLabel;
}

- (UILabel *)gradeNumberLabel {
    if (_gradeNumberLabel == nil) {
        _gradeNumberLabel = [[UILabel alloc] init];
        _gradeNumberLabel.text = @"";
        _gradeNumberLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _gradeNumberLabel.font = [UIFont systemFontOfSize:10];
        _gradeNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _gradeNumberLabel;
}

- (UILabel *)promoTypeLabel {
    if (_promoTypeLabel == nil) {
        _promoTypeLabel = [[UILabel alloc] init];
        _promoTypeLabel.text = @"SPECIAL PROMO";
        _promoTypeLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        _promoTypeLabel.font = [UIFont systemFontOfSize:8];
        _promoTypeLabel.backgroundColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        _promoTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promoTypeLabel;
}

- (UIImageView *)gradeImageView  {
    if (_gradeImageView == nil) {
        _gradeImageView = [[UIImageView alloc] init];
        _gradeImageView.image = [UIImage imageNamed:@"rank_star"];
    }
    return _gradeImageView;
}



@end
