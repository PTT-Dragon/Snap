//
//  ProductCheckoutBuyView.m
//  SFShop
//
//  Created by MasterFly on 2021/11/4.
//

#import "ProductCheckoutBuyView.h"
#import "SysParamsModel.h"

@interface ProductCheckoutBuyView ()
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *desLabel;
@property (nonatomic, readwrite, strong) UIButton *buyBtn;
@end
@implementation ProductCheckoutBuyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadubsviews];
        [self layout];
    }
    return self;
}

- (void)loadubsviews {
    [self addSubview:self.priceLabel];
    [self addSubview:self.desLabel];
    [self addSubview:self.buyBtn];
}

- (void)layout {
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(160, 46));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(19);
        make.right.lessThanOrEqualTo(self.buyBtn.mas_left).offset(-2);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-5);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(12);
        make.right.lessThanOrEqualTo(self.buyBtn.mas_left).offset(-2);
    }];
}
    
#pragma mark - Event
- (void)btnClick:(UIButton *)btn {
    if (self.buyBlock) {
        self.buyBlock();
    }
}

#pragma mark - Get and Set
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
    NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %.3f",currency,dataModel.feeModel.totalPrice.fee];
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _priceLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.textColor = [UIColor jk_colorWithHexString:@"#999999"];
        _desLabel.font = [UIFont systemFontOfSize:10];
        _desLabel.text = kLocalizedString(@"Total");
    }
    return _desLabel;
}

- (UIButton *)buyBtn {
    if (_buyBtn == nil) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setBackgroundColor:[UIColor jk_colorWithHexString:@"#FF1659"]];
        [_buyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_buyBtn setTitle:kLocalizedString(@"Place_order") forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _buyBtn;
}

@end
