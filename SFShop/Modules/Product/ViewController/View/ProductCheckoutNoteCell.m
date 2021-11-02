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
    
  
}

#pragma mark - Getter
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
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
        _noteLabel.text = @"Notes";
        _noteLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _noteLabel.font = [UIFont boldSystemFontOfSize:14];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _noteLabel;
}

- (UILabel *)couponLabel {
    if (_couponLabel == nil) {
        _couponLabel = [[UILabel alloc] init];
        _couponLabel.text = @"Coupon";
        _couponLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _couponLabel.font = [UIFont boldSystemFontOfSize:14];
        _couponLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _couponLabel;
}

- (UILabel *)couponPriceLabel {
    if (_couponPriceLabel == nil) {
        _couponPriceLabel = [[UILabel alloc] init];
        _couponPriceLabel.text = @"Coupon";
        _couponPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _couponPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        _couponPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _couponPriceLabel;
}

- (UIButton *)couponNextBtn {
    if (_couponNextBtn == nil) {
        _couponNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_couponNextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_couponNextBtn setBackgroundColor:[UIColor redColor]];
    }
    return _couponNextBtn;
}

- (UILabel *)promoLabel {
    if (_promoLabel == nil) {
        _promoLabel = [[UILabel alloc] init];
        _promoLabel.text = @"Store promo";
        _promoLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _promoLabel.font = [UIFont boldSystemFontOfSize:14];
        _promoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _promoLabel;
}

- (UILabel *)promoPriceLabel {
    if (_promoPriceLabel == nil) {
        _promoPriceLabel = [[UILabel alloc] init];
        _promoPriceLabel.text = @"";
        _promoPriceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _promoPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        _promoPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _promoPriceLabel;
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = @"";
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
