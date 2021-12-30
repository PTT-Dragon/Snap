//
//  ProductCheckoutSectionHeader.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutSectionHeader.h"

@interface ProductCheckoutSectionHeader ()
@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UIImageView *icon;
@end

@implementation ProductCheckoutSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        [self loadSubviews];
        [self layout];
    }
    return self;
}

- (void)loadSubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.icon];
}

- (void)layout {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(4);
        make.right.mas_equalTo(-20);
    }];
}

#pragma mark - Get and Set
- (void)setCellModel:(SFCellCacheModel *)cellModel {
    _cellModel = cellModel;
    if ([cellModel.cellId isEqualToString:@"ProductCheckoutAddressCell"]) {
        self.titleLabel.hidden = NO;
        self.icon.hidden = NO;
        self.titleLabel.text = kLocalizedString(@"Delivery_address");
        self.icon.image = [UIImage imageNamed:@"checkout_address"];
    } else if ([cellModel.cellId isEqualToString:@"ProductCheckoutGoodsCell"]) {
        self.titleLabel.hidden = NO;
        self.icon.hidden = NO;
        ProductCheckoutSubItemModel *item = cellModel.obj;
        self.titleLabel.text = item.storeName;
        self.icon.image = [UIImage imageNamed:@"checkout_product"];
    } else if ([cellModel.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
        self.titleLabel.hidden = NO;
        self.icon.hidden = NO;
        self.titleLabel.text = kLocalizedString(@"Delivery");
        self.icon.image = [UIImage imageNamed:@"checkout_delivery"];
    } else if ([cellModel.cellId isEqualToString:@"ProductCheckoutNoteCell"] ||
               [cellModel.cellId isEqualToString:@"ProductCheckoutVoucherCell"]) {
        self.titleLabel.hidden = YES;
        self.icon.hidden = YES;
    }
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

@end
