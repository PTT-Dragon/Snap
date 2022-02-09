//
//  DeliveryCell.m
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import "DeliveryCell.h"

@interface DeliveryCell ()
@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UIView *leftBgView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *desLabel;
@end

@implementation DeliveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadubsviews];
        [self layout];
    }
    return self;
}

- (void)loadubsviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.priceLabel];
    [self.bgView addSubview:self.leftBgView];
    [self.leftBgView addSubview:self.titleLabel];
    [self.leftBgView addSubview:self.desLabel];
}

- (void)layout {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.leftBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(self.priceLabel.mas_left).offset(-10);
        make.centerY.mas_equalTo(0);
        make.top.equalTo(self.titleLabel);
        make.bottom.equalTo(self.desLabel);
    }];

    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

#pragma mark - Getter
- (void)setItem:(OrderLogisticsItem *)item {
    _item = item;
    self.titleLabel.text = item.logisticsModeName;
    self.priceLabel.text = item.priceStr;
    self.desLabel.text = item.dateStr;
    [self layout];
    
    if (item.isSelected) {
        self.bgView.layer.borderColor = [UIColor jk_colorWithHexString:@"#FF1659"].CGColor;
    } else {
        self.bgView.layer.borderColor = [UIColor jk_colorWithHexString:@"#CCCCCC"].CGColor;
    }
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.borderWidth = 1;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)leftBgView {
    if (_leftBgView == nil) {
        _leftBgView = [[UIView alloc] init];
        _leftBgView.backgroundColor = [UIColor whiteColor];
    }
    return _leftBgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"";
        _priceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"";
        _desLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _desLabel;
}

@end
