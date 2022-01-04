//
//  ProductCheckoutNoteCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutNoteCell.h"
#import "CustomTextField.h"

@interface ProductCheckoutNoteCell ()
@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UIView *sectionLine;
@property (nonatomic, readwrite, strong) UILabel *noteLabel;
@property (nonatomic, readwrite, strong) CustomTextField *noteTF;

@property (nonatomic, readwrite, strong) UILabel *couponLabel;
@property (nonatomic, readwrite, strong) UILabel *couponPriceLabel;
@property (nonatomic, readwrite, strong) UIButton *couponNextBtn;

@property (nonatomic, readwrite, strong) UILabel *promoLabel;
@property (nonatomic, readwrite, strong) UILabel *promoPriceLabel;

@property (nonatomic, readwrite, strong) UILabel *totalLabel;
@property (nonatomic, readwrite, strong) UILabel *totalPriceLabel;
@end

@implementation ProductCheckoutNoteCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        [self loadubsviews];
        [self layout];
    }
    return self;
}

- (void)loadubsviews {
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.sectionLine];

    [self.bgView addSubview:self.noteLabel];
    [self.bgView addSubview:self.noteTF];
    [self.bgView addSubview:self.couponLabel];
    [self.bgView addSubview:self.couponPriceLabel];
    [self.bgView addSubview:self.couponNextBtn];
    [self.bgView addSubview:self.promoLabel];
    [self.bgView addSubview:self.promoPriceLabel];
    [self.bgView addSubview:self.totalLabel];
    [self.bgView addSubview:self.totalPriceLabel];
}

- (void)layout {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.noteTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(14);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
    }];
    
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.noteTF);
        make.left.mas_equalTo(20);
        make.right.lessThanOrEqualTo(self.noteTF.mas_left).offset(-10);
    }];
    
    [self.couponNextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.equalTo(self.noteTF.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.couponPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.couponNextBtn.mas_left).offset(-10);
        make.top.bottom.equalTo(self.couponNextBtn);
    }];
    
    [self.couponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.equalTo(self.couponNextBtn);
        make.right.lessThanOrEqualTo(self.couponPriceLabel.mas_left).offset(-10);
    }];
    
    [self.promoPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.couponNextBtn.mas_bottom).offset(8);
        make.height.mas_equalTo(17);
    }];
    
    [self.promoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.equalTo(self.promoPriceLabel);
        make.right.lessThanOrEqualTo(self.promoPriceLabel.mas_left).offset(-10);
    }];
    
    [self.totalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.promoLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(18);
    }];
    
    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.equalTo(self.totalPriceLabel);
        make.right.lessThanOrEqualTo(self.totalPriceLabel.mas_left).offset(-10);
    }];
}

#pragma mark - Event
- (void)btnClick:(UIButton *)btn {
    !self.eventBlock?:self.eventBlock(self.dataModel, self.cellModel, ProductCheckoutCellEvent_GotoStoreVoucher);
}

#pragma mark - Getter
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
    super.dataModel = dataModel;
    NSInteger availableVouchersCount = dataModel.couponsModel.storeAvailableCoupons.firstObject.availableCoupons.count;
    if (dataModel.currentStoreCoupon) {//如果选中优惠券,那么显示优惠券减少的价格
        self.couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        self.couponPriceLabel.text = [NSString stringWithFormat:@"- %@ %.3f",dataModel.priceRp,dataModel.currentStoreCoupon.discountAmount / 1000.0];
    } else if (!availableVouchersCount) {//如果没选中优惠券也没有有效优惠券,那么显示无有效优惠券
        self.couponPriceLabel.text = kLocalizedString(@"Not_available");
        self.couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
    } else {
        self.couponPriceLabel.text = [NSString stringWithFormat:@"%ld available",availableVouchersCount];
        self.couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
    }
    self.promoPriceLabel.text = [NSString stringWithFormat:@"- %@ %.3f",dataModel.priceRp,dataModel.promoReduce];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%@ %.3f",dataModel.priceRp,dataModel.totalPrice];
    [self layout];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)noteLabel {
    if (_noteLabel == nil) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.text = kLocalizedString(@"Notes");
        _noteLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _noteLabel.font = [UIFont systemFontOfSize:14];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _noteLabel;
}

- (UILabel *)couponLabel {
    if (_couponLabel == nil) {
        _couponLabel = [[UILabel alloc] init];
        _couponLabel.text = kLocalizedString(@"Voucher");
        _couponLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _couponLabel.font = [UIFont systemFontOfSize:14];
        _couponLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _couponLabel;
}

- (UILabel *)couponPriceLabel {
    if (_couponPriceLabel == nil) {
        _couponPriceLabel = [[UILabel alloc] init];
        _couponPriceLabel.text = @"";
        _couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _couponPriceLabel.font = [UIFont systemFontOfSize:14];
        _couponPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _couponPriceLabel;
}

- (UIButton *)couponNextBtn {
    if (_couponNextBtn == nil) {
        _couponNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_couponNextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_couponNextBtn setImage:[UIImage imageNamed:@"right-scroll"] forState:UIControlStateNormal];
    }
    return _couponNextBtn;
}

- (UILabel *)promoLabel {
    if (_promoLabel == nil) {
        _promoLabel = [[UILabel alloc] init];
        _promoLabel.text = kLocalizedString(@"Store_promo");
        _promoLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _promoLabel.font = [UIFont systemFontOfSize:14];
        _promoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _promoLabel;
}

- (UILabel *)promoPriceLabel {
    if (_promoPriceLabel == nil) {
        _promoPriceLabel = [[UILabel alloc] init];
        _promoPriceLabel.text = @"";
        _promoPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        _promoPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        _promoPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _promoPriceLabel;
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = kLocalizedString(@"Total");
        _totalLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _totalLabel.font = [UIFont boldSystemFontOfSize:14];
        _totalLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalLabel;
}

- (UILabel *)totalPriceLabel {
    if (_totalPriceLabel == nil) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.text = @"";
        _totalPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _totalPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalPriceLabel;
}

- (CustomTextField *)noteTF {
    if (_noteTF == nil) {
        _noteTF = [[CustomTextField alloc] init];
        _noteTF.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _noteTF.font = [UIFont systemFontOfSize:12];
        _noteTF.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    }
    return _noteTF;
}

@end
