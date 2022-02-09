//
//  ProductCheckoutVoucherCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutVoucherCell.h"
#import "SysParamsModel.h"

@interface ProductCheckoutVoucherCell ()
@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UILabel *subTitleLabel;
@property (nonatomic, readwrite, strong) UIButton *nextBtn;
@end

@implementation ProductCheckoutVoucherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        [self loadsubviews];
        [self layout];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.subTitleLabel];
    [self.bgView addSubview:self.nextBtn];
}

- (void)layout {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextBtn.mas_left).offset(-10);
        make.top.bottom.equalTo(self.nextBtn);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.bottom.equalTo(self.nextBtn);
        make.centerY.mas_equalTo(0);
    }];
}
- (void)btnClick:(UIButton *)btn
{
    
}

#pragma mark - Get and Set
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
    super.dataModel = dataModel;
    NSInteger shopAvailableVouchersCount = dataModel.couponsModel.pltAvailableCoupons.count;
    if (!shopAvailableVouchersCount) {//如果没选中优惠券也没有有效优惠券,那么显示无有效优惠券
        self.subTitleLabel.text = kLocalizedString(@"NOT_AVAILABLE");
        self.subTitleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
    } else {
        if (dataModel.currentPltCoupon) {
            self.subTitleLabel.text = [@"- " stringByAppendingString:[NSString stringWithFormat:@"%ld",dataModel.currentPltCoupon.discountAmount].currency];
            self.subTitleLabel.textColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        } else {
            self.subTitleLabel.text = [NSString stringWithFormat:@"%ld %@",shopAvailableVouchersCount, kLocalizedString(@"AVAILABLE_COUPON")];
            self.subTitleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        }
    }
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setImage:[UIImage imageNamed:@"right-scroll"] forState:UIControlStateNormal];
    }
    return _nextBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kLocalizedString(@"SF_shop_Voucher");
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subTitleLabel;
}


@end
