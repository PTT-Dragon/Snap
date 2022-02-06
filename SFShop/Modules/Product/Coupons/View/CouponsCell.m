//
//  CouponsCell.m
//  SFShop
//
//  Created by MasterFly on 2022/1/3.
//USE_NOW

#import "CouponsCell.h"
#import "NSDate+Helper.h"
#import "NSString+Fee.h"

@interface CouponsCell ()
@property (nonatomic, readwrite, strong) UIView *iconBg;
@property (nonatomic, readwrite, strong) UIImageView *icon;
@property (nonatomic, readwrite, strong) UILabel *iconTitlelabel;

@property (nonatomic, readwrite, strong) UIView *contentBg;
@property (nonatomic, readwrite, strong) UILabel *discountLabel;
@property (nonatomic, readwrite, strong) UILabel *expireTitleLabel;
@property (nonatomic, readwrite, strong) UILabel *expireContentLabel;
@end

@implementation CouponsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self loadsubviews];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.iconBg];
    [self.iconBg addSubview:self.icon];
    [self.iconBg addSubview:self.iconTitlelabel];
    
    [self.contentView addSubview:self.contentBg];
    [self.contentBg addSubview:self.discountLabel];
    [self.contentBg addSubview:self.expireTitleLabel];
    [self.contentBg addSubview:self.expireContentLabel];
}

- (void)layout {
    [self.iconBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(self.iconBg.mas_right);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    [self.iconTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.expireTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.expireContentLabel.mas_top).offset(-9);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.expireContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.right.mas_equalTo(-12);
    }];
}

#pragma mark - Get and Set
- (void)setItem:(CouponItem *)item {
    NSString *discount = [NSString stringWithFormat:@"Discount %.3f ",item.discountAmount * 0.001];
    NSString *spendMin = [NSString stringWithFormat:@"Min.Spend %.3f ",item.thAmount * 0.001];
    if (item.thAmount) {
        self.discountLabel.text = [discount stringByAppendingString:spendMin];
    } else {
        self.discountLabel.text = discount;
    }
    if ([item.discountMethod isEqualToString:@"DISC"]) {
        self.discountLabel.text = [NSString stringWithFormat:@"%@ %.2f%% Min.spend %.2f",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0ld",item.discountAmount] currencyFloat],[[NSString stringWithFormat:@"%ld",item.thAmount] currencyFloat]];
    }else{
        self.discountLabel.text = [NSString stringWithFormat:@"%@ %@ Without limit",kLocalizedString(@"DISCOUNT"),[[NSString stringWithFormat:@"%.0ld",item.discountAmount] currency]];
    }
    
    if (item.effDate.length > 0 && item.expDate.length > 0) {
        self.expireContentLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:item.effDate] dayMonthYear],[[NSDate dateFromString:item.expDate] dayMonthYear]];
    }
    
    if (item.isSelected) {
        self.contentBg.layer.borderColor = [UIColor jk_colorWithHexString:@"#FF1659"].CGColor;
    } else {
        self.contentBg.layer.borderColor = [UIColor jk_colorWithHexString:@"#CCCCCC"].CGColor;
    }
    
    [self layout];
}

- (UIView *)contentBg {
    if (_contentBg == nil) {
        _contentBg = [[UIView alloc] init];
        _contentBg.layer.borderColor = [UIColor jk_colorWithHexString:@"#CCCCCC"].CGColor;
        _contentBg.layer.borderWidth = 0.5;
    }
    return _contentBg;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"discountVoucher"];
    }
    return _icon;
}

- (UILabel *)iconTitlelabel {
    if (_iconTitlelabel == nil) {
        _iconTitlelabel = [[UILabel alloc] init];
        _iconTitlelabel.text = kLocalizedString(@"DISCOUNT");
        _iconTitlelabel.textColor = [UIColor whiteColor];
        _iconTitlelabel.font = [UIFont systemFontOfSize:12];
        _iconTitlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _iconTitlelabel;
}

- (UIView *)iconBg {
    if (_iconBg == nil) {
        _iconBg = [[UIView alloc] init];
        _iconBg.backgroundColor = [UIColor jk_colorWithHexString:@"#FF1659"];
    }
    return _iconBg;
}

- (UILabel *)discountLabel {
    if (_discountLabel == nil) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.numberOfLines = 2;
        _discountLabel.textColor = [UIColor blackColor];
        _discountLabel.font = [UIFont systemFontOfSize:14];
        _discountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _discountLabel;
}

- (UILabel *)expireTitleLabel {
    if (_expireTitleLabel == nil) {
        _expireTitleLabel = [[UILabel alloc] init];
        _expireTitleLabel.text = kLocalizedString(@"EXPIRY_DATE");
        _expireTitleLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _expireTitleLabel.font = [UIFont systemFontOfSize:10];
        _expireTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _expireTitleLabel;
}

- (UILabel *)expireContentLabel {
    if (_expireContentLabel == nil) {
        _expireContentLabel = [[UILabel alloc] init];
        _expireContentLabel.textColor = [UIColor blackColor];
        _expireContentLabel.font = [UIFont systemFontOfSize:12];
        _expireContentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _expireContentLabel;
}

@end
